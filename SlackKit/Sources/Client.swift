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

public final class Client: WebSocketDelegate {
    
    internal(set) public var connected = false
    internal(set) public var authenticatedUser: User?
    internal(set) public var team: Team?
    
    internal(set) public var channels = [String: Channel]()
    internal(set) public var users = [String: User]()
    internal(set) public var userGroups = [String: UserGroup]()
    internal(set) public var bots = [String: Bot]()
    internal(set) public var files = [String: File]()
    internal(set) public var sentMessages = [String: Message]()
    
    public var token = "xoxp-SLACK_AUTH_TOKEN"
    
    public var webAPI: WebAPI {
        return WebAPI(token: token)
    }

    internal var webSocket: WebSocket?
    private let pingPongQueue = dispatch_queue_create("com.launchsoft.SlackKit", DISPATCH_QUEUE_SERIAL)
    internal var ping: Double?
    internal var pong: Double?
    internal var options: ClientOptions?
        
    //MARK: - Delegates
    public weak var connectionEventsDelegate: ConnectionEventsDelegate?
    public weak var slackEventsDelegate: SlackEventsDelegate?
    public weak var messageEventsDelegate: MessageEventsDelegate?
    public weak var doNotDisturbEventsDelegate: DoNotDisturbEventsDelegate?
    public weak var channelEventsDelegate: ChannelEventsDelegate?
    public weak var groupEventsDelegate: GroupEventsDelegate?
    public weak var fileEventsDelegate: FileEventsDelegate?
    public weak var pinEventsDelegate: PinEventsDelegate?
    public weak var starEventsDelegate: StarEventsDelegate?
    public weak var reactionEventsDelegate: ReactionEventsDelegate?
    public weak var teamEventsDelegate: TeamEventsDelegate?
    public weak var subteamEventsDelegate: SubteamEventsDelegate?
    public weak var teamProfileEventsDelegate: TeamProfileEventsDelegate?

    // If you already have an API token
    internal init(apiToken: String) {
        self.token = apiToken
    }
    
    public func setAuthToken(token: String) {
        self.token = token
    }
    
    public func connect(options options: ClientOptions = ClientOptions()) {
        self.options = options
        webAPI.rtmStart(options.simpleLatest, noUnreads: options.noUnreads, mpimAware: options.mpimAware, success: {
            (response) -> Void in
            guard let socketURL = response["url"] as? String, url = NSURL(string: socketURL) else {
                return
            }
            self.initialSetup(response)
            self.webSocket = WebSocket(url: url)
            self.webSocket?.delegate = self
            self.webSocket?.connect()
            }, failure: {(error) -> Void in
                self.connectionEventsDelegate?.clientConnectionFailed(self, error: error)
            })
    }
    
    public func disconnect() {
        webSocket?.disconnect()
    }
    
    //MARK: - RTM Message send
    public func sendMessage(message: String, channelID: String) {
        guard connected else { return }

        if let data = try? formatMessageToSlackJsonString(msg: message, channel: channelID),
            string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String {
            webSocket?.writeString(string)
        }
    }
    
    private func formatMessageToSlackJsonString(message: (msg: String, channel: String)) throws -> NSData {
        let json: [String: AnyObject] = [
            "id": NSDate().slackTimestamp(),
            "type": "message",
            "channel": message.channel,
            "text": message.msg.slackFormatEscaping()
        ]
        addSentMessage(json)
        return try NSJSONSerialization.dataWithJSONObject(json, options: [])
    }
    
    private func addSentMessage(dictionary: [String: AnyObject]) {
        var message = dictionary
        guard let id = message["id"] as? NSNumber else {
            return
        }
        let ts = String(id)
        message.removeValueForKey("id")
        message["ts"] = ts
        message["user"] = self.authenticatedUser?.id
        sentMessages[ts] = Message(message: message)
    }
    
    //MARK: - RTM Ping
    private func pingRTMServerAtInterval(interval: NSTimeInterval) {
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
        dispatch_after(delay, pingPongQueue, {
            guard self.connected && self.timeoutCheck() else {
                self.disconnect()
                return
            }
            self.sendRTMPing()
            self.pingRTMServerAtInterval(interval)
        })
    }
    
    private func sendRTMPing() {
        guard connected else {
            return
        }
        let json: [String: AnyObject] = [
            "id": NSDate().slackTimestamp(),
            "type": "ping",
        ]
        guard let data = try? NSJSONSerialization.dataWithJSONObject(json, options: []) else {
            return
        }
        let string = NSString(data: data, encoding: NSUTF8StringEncoding)
        if let writePing = string as? String {
            ping = json["id"] as? Double
            webSocket?.writeString(writePing)
        }
    }
    
    private func timeoutCheck() -> Bool {
        if let pong = pong, ping = ping, timeout = options?.timeout {
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
        let user = User(user: aUser)
        if let id = user.id {
            users[id] = user
        }
    }
    
    private func addChannel(aChannel: [String: AnyObject]) {
        let channel = Channel(channel: aChannel)
        if let id = channel.id {
            channels[id] = channel
        }
    }
    
    private func addBot(aBot: [String: AnyObject]) {
        let bot = Bot(bot: aBot)
        if let id = bot.id {
            bots[id] = bot
        }
    }
    
    private func enumerateSubteams(subteams: [String: AnyObject]?) {
        if let subteams = subteams {
            if let all = subteams["all"] as? [[String: AnyObject]] {
                for item in all {
                    let u = UserGroup(userGroup: item)
                    self.userGroups[u.id!] = u
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
    private func enumerateObjects(array: [AnyObject]?, initializer: ([String: AnyObject])-> Void) {
        if let array = array {
            for object in array {
                if let dictionary = object as? [String: AnyObject] {
                    initializer(dictionary)
                }
            }
        }
    }
    
    // MARK: - WebSocketDelegate
    public func websocketDidConnect(socket: WebSocket) {
        if let pingInterval = options?.pingInterval {
            pingRTMServerAtInterval(pingInterval)
        }
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        connected = false
        webSocket = nil
        authenticatedUser = nil
        connectionEventsDelegate?.clientDisconnected(self)
        if let options = options where options.reconnect == true {
            connect(options: options)
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }

        if let json = (try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)) as? [String: AnyObject] {
            dispatch(json)
        }
    }

    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {}
    
}
