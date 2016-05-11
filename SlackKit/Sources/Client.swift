//
// Client.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Starscream

public class Client: WebSocketDelegate {
    
    internal(set) public var connected = false
    internal(set) public var authenticated = false
    internal(set) public var authenticatedUser: User?
    internal(set) public var team: Team?
    
    internal(set) public var channels = [String: Channel]()
    internal(set) public var users = [String: User]()
    internal(set) public var userGroups = [String: UserGroup]()
    internal(set) public var bots = [String: Bot]()
    internal(set) public var files = [String: File]()
    internal(set) public var sentMessages = [String: Message]()
    
    //MARK: - Delegates
    public var slackEventsDelegate: SlackEventsDelegate?
    public var messageEventsDelegate: MessageEventsDelegate?
    public var doNotDisturbEventsDelegate: DoNotDisturbEventsDelegate?
    public var channelEventsDelegate: ChannelEventsDelegate?
    public var groupEventsDelegate: GroupEventsDelegate?
    public var fileEventsDelegate: FileEventsDelegate?
    public var pinEventsDelegate: PinEventsDelegate?
    public var starEventsDelegate: StarEventsDelegate?
    public var reactionEventsDelegate: ReactionEventsDelegate?
    public var teamEventsDelegate: TeamEventsDelegate?
    public var subteamEventsDelegate: SubteamEventsDelegate?
    public var teamProfileEventsDelegate: TeamProfileEventsDelegate?
    
    public var token = "SLACK_AUTH_TOKEN"
    
    public func setAuthToken(token: String) {
        self.token = token
    }
    
    public var webAPI: SlackWebAPI {
        return SlackWebAPI(client: self)
    }

    internal var webSocket: WebSocket?
    internal let api = NetworkInterface()

    private let pingPongQueue = dispatch_queue_create("com.launchsoft.SlackKit", DISPATCH_QUEUE_SERIAL)
    internal var ping: Double?
    internal var pong: Double?
    
    internal var pingInterval: NSTimeInterval?
    internal var timeout: NSTimeInterval?
    internal var reconnect: Bool?
    
    required public init(apiToken: String) {
        self.token = apiToken
    }
    
    public func connect(simpleLatest simpleLatest: Bool? = nil, noUnreads: Bool? = nil, mpimAware: Bool? = nil, pingInterval: NSTimeInterval? = nil, timeout: NSTimeInterval? = nil, reconnect: Bool? = nil) {
        self.pingInterval = pingInterval
        self.timeout = timeout
        self.reconnect = reconnect
        webAPI.rtmStart(simpleLatest, noUnreads: noUnreads, mpimAware: mpimAware, success: {
            (response) -> Void in
            self.initialSetup(response)
            if let socketURL = response["url"] as? String {
                let url = NSURL(string: socketURL)
                self.webSocket = WebSocket(url: url!)
                self.webSocket?.delegate = self
                self.webSocket?.connect()
            }
            }, failure: {(error) -> Void in
                self.slackEventsDelegate?.clientConnectionFailed(error)
            })
    }
    
    public func disconnect() {
        webSocket?.disconnect()
    }
    
    //MARK: - RTM Message send
    public func sendMessage(message: String, channelID: String) {
        if (connected) {
            if let data = formatMessageToSlackJsonString(msg: message, channel: channelID) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
                    webSocket?.writeString(string)
                }
            }
        }
    }
    
    private func formatMessageToSlackJsonString(message: (msg: String, channel: String)) -> NSData? {
        let json: [String: AnyObject] = [
            "id": NSDate().slackTimestamp(),
            "type": "message",
            "channel": message.channel,
            "text": message.msg.slackFormatEscaping()
        ]
        addSentMessage(json)
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
            return data
        }
        catch _ {
            return nil
        }
    }
    
    private func addSentMessage(dictionary: [String: AnyObject]) {
        var message = dictionary
        let ts = message["id"] as? NSNumber
        message.removeValueForKey("id")
        message["ts"] = ts?.stringValue
        message["user"] = self.authenticatedUser?.id
        sentMessages[ts!.stringValue] = Message(message: message)
    }
    
    //MARK: - RTM Ping
    private func pingRTMServerAtInterval(interval: NSTimeInterval) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
        dispatch_after(delay, pingPongQueue, {
            if self.connected && self.timeoutCheck() {
                self.sendRTMPing()
                self.pingRTMServerAtInterval(interval)
            } else {
                self.disconnect()
            }
        })
    }
    
    private func sendRTMPing() {
        if connected {
            let json: [String: AnyObject] = [
                "id": NSDate().slackTimestamp(),
                "type": "ping",
            ]
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
                let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let writePing = string as? String {
                    ping = json["id"] as? Double
                    webSocket?.writeString(writePing)
                }
            }
            catch _ {
                
            }
        }
    }
    
    private func timeoutCheck() -> Bool {
        if let pong = pong, ping = ping, timeout = timeout {
            if pong - ping < timeout {
                return true
            } else {
                return false
            }
        // Ping-pong or timeout not configured
        } else {
            return true
        }
    }
    
    //MARK: - Client setup
    private func initialSetup(json: [String: AnyObject]) {
        team = Team(team: json["team"] as? [String: AnyObject])
        authenticatedUser = User(user: json["self"] as? [String: AnyObject])
        authenticatedUser?.doNotDisturbStatus = DoNotDisturbStatus(status: json["dnd"] as? [String: AnyObject])
        enumerateObjects(json["users"] as? Array) { (user) in self.addUser(user) }
        enumerateObjects(json["channels"] as? Array) { (channel) in self.addChannel(channel) }
        enumerateObjects(json["groups"] as? Array) { (group) in self.addChannel(group) }
        enumerateObjects(json["mpims"] as? Array) { (mpim) in self.addChannel(mpim) }
        enumerateObjects(json["ims"] as? Array) { (ims) in self.addChannel(ims) }
        enumerateObjects(json["bots"] as? Array) { (bots) in self.addBot(bots) }
        enumerateSubteams(json["subteams"] as? [String: AnyObject])
    }
    
    private func addUser(aUser: [String: AnyObject]) {
        if let user = User(user: aUser), id = user.id {
            users[id] = user
        }
    }
    
    private func addChannel(aChannel: [String: AnyObject]) {
        if let channel = Channel(channel: aChannel), id = channel.id {
            channels[id] = channel
        }
    }
    
    private func addBot(aBot: [String: AnyObject]) {
        if let bot = Bot(bot: aBot), id = bot.id {
            bots[id] = bot
        }
    }
    
    private func enumerateSubteams(subteams: [String: AnyObject]?) {
        if let subteams = subteams {
            if let all = subteams["all"] as? [[String: AnyObject]] {
                for item in all {
                    let u = UserGroup(userGroup: item)
                    self.userGroups[u!.id!] = u
                }
            }
            if let auth = subteams["self"] as? [String] {
                for item in auth {
                    authenticatedUser?.userGroups = [String: String]()
                    authenticatedUser?.userGroups![item] = item
                }
            }
        }
    }
    
    // MARK: - Utilities
    private func enumerateObjects(array: [AnyObject]?, initalizer: ([String: AnyObject])-> Void) {
        if let array = array {
            for object in array {
                if let dictionary = object as? [String: AnyObject] {
                    initalizer(dictionary)
                }
            }
        }
    }
    
    // MARK: - WebSocketDelegate
    public func websocketDidConnect(socket: WebSocket) {
        if let pingInterval = pingInterval {
            pingRTMServerAtInterval(pingInterval)
        }
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        connected = false
        authenticated = false
        webSocket = nil
        authenticatedUser = nil
        slackEventsDelegate?.clientDisconnected()
        if reconnect == true {
            connect(pingInterval: pingInterval, timeout: timeout, reconnect: reconnect)
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [String: AnyObject] {
                dispatch(json)
            }
        }
        catch _ {
            
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {}
    
}
