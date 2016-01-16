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

    private var token = "SLACK_AUTH_TOKEN"
    private let apiUrl = "https://slack.com/api/"

    public func setAuthToken(token: String) {
        self.token = token
    }
    
    private var webSocket: WebSocket?
    
    required public init() {
        
    }
    
    public static let sharedInstance = Client()
    
    //MARK: - Connection
    public func connect() {
        let request = NSURLRequest(URL: NSURL(string: "\(apiUrl)rtm.start?token=\(token)")!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) {
            (response, data, error) -> Void in
            guard let data = data else {
                return
            }
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
                if (result["ok"] as! Bool == true) {
                    self.initialSetup(result)
                    let socketURL = NSURL(string: result["url"] as! String)
                    self.webSocket = WebSocket(url: socketURL!)
                    self.webSocket?.delegate = self
                    self.webSocket?.connect()
                }
            } catch _ {
                print(error)
            }
        }
    }
    
    //MARK: - User & Channel
    public func getChannelOrUserIdByName(name: String) -> String? {
        if (name[name.startIndex] == "@") {
            return getUserIdByName(name)
        } else if (name[name.startIndex] == "C") {
            return getChannelIDByName(name)
        }
        return nil
    }

    public func getChannelIDByName(name: String) -> String? {
        var cleanName = name
        if(name[name.startIndex] == "#") {
            cleanName = name.substringFromIndex(name.startIndex.advancedBy(1))
        }
        for (id, channel) in channels {
            if (channel.name == cleanName) {
                return id
            }
        }
        return nil
    }

    public func getUserIdByName(name: String) -> String? {
        var cleanName = name
        if(name[name.startIndex] == "@") {
            cleanName = name.substringFromIndex(name.startIndex.advancedBy(1))
        }
        for (id, user) in users {
            if (user.name == cleanName) {
                return id
            }
        }
        return nil
    }

    public func getIdDM(id: String, callback: (String?) -> Void) {
        let cleanId = id.substringFromIndex(id.startIndex.advancedBy(1))
        if (id[id.startIndex.advancedBy(0)] == "C") { // It's a channel, dirrectly return the ID
            callback("D" + cleanId)
        } else { // It's a user
            if let idDM = self.users[id]?.idDM, let lastUpdateidDM = self.users[id]?.lastUpdateDM {
                if (NSDate().timeIntervalSince1970 - lastUpdateidDM <= 24*60*60) { // try to get from 24h cache first
                    callback(idDM)
                } else { // expired, request from api to get new DM ID
                    imOpen(id, callback: callback)
                }
            } else { // request from api to get new DM ID
                imOpen(id, callback: callback)
            }
        }
    }

    private func imOpen(id: String, callback: (String?) -> Void) {
        let request = NSURLRequest(URL: NSURL(string: "\(apiUrl)im.open?token=\(token)&user=\(id)")!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.currentQueue()!) {
            (response, data, error) -> Void in
            guard let data = data else {
                return
            }
            do {
                let dict: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if (dict["ok"] as! Bool == true) {
                    let _id: String = (dict["channel"]?["id"])! as! String
                    self.users[id]?.updateIdDM(_id)
                    callback(_id)
                } else {
                    callback(nil)
                }
            } catch _ {
                print(error)
            }
        }
    }

    //MARK: - Message send
    public func sendMessage(message: String, channelID: String) {
        if (connected) {
            if let data = formatMessageToSlackJsonString(msg: message, channel: channelID) {
                let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.webSocket?.writeString(string as! String)
            }
        }
    }
    
    private func formatMessageToSlackJsonString(message: (msg: String, channel: String)) -> NSData? {
        let json: [String: AnyObject] = [
            "id": NSDate().timeIntervalSince1970,
            "type": "message",
            "channel": message.channel,
            "text": slackFormatEscaping(message.msg)
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
    
    private func slackFormatEscaping(string: String) -> String {
        var escapedString = string.stringByReplacingOccurrencesOfString("&", withString: "&amp;")
        escapedString = escapedString.stringByReplacingOccurrencesOfString("<", withString: "&lt;")
        escapedString = escapedString.stringByReplacingOccurrencesOfString(">", withString: "&gt;")
        return escapedString
    }
    
    //MARK: - Client setup
    private func initialSetup(json: [String: AnyObject]) {
        team = Team(team: json["team"] as? [String: AnyObject])
        authenticatedUser = User(user: json["self"] as? [String: AnyObject])
        authenticatedUser?.doNotDisturbStatus = DoNotDisturbStatus(status: json["dnd"] as? [String: AnyObject])
        enumerateUsers(json["users"] as? Array)
        enumerateChannels(json["channels"] as? Array)
        enumerateGroups(json["groups"] as? Array)
        enumerateMPIMs(json["mpims"] as? Array)
        enumerateIMs(json["ims"] as? Array)
        enumerateBots(json["bots"] as? Array)
        enumerateSubteams(json["subteams"] as? [String: AnyObject])
    }
    
    private func enumerateUsers(users: [AnyObject]?) {
        if let users = users {
            for user in users {
                let u = User(user: user as? [String: AnyObject])
                self.users[u!.id!] = u
            }
        }
    }
    
    private func enumerateChannels(channels: [AnyObject]?) {
        if let channels = channels {
            for channel in channels {
                let c = Channel(channel: channel as? [String: AnyObject])
                self.channels[c!.id!] = c
            }
        }
    }
    
    private func enumerateGroups(groups: [AnyObject]?) {
        if let groups = groups {
            for group in groups {
                let g = Channel(channel: group as? [String: AnyObject])
                self.channels[g!.id!] = g
            }
        }
    }
    
    private func enumerateIMs(ims: [AnyObject]?) {
        if let ims = ims {
            for im in ims {
                let i = Channel(channel: im as? [String: AnyObject])
                self.channels[i!.id!] = i
            }
        }
    }
    
    private func enumerateMPIMs(mpims: [AnyObject]?) {
        if let mpims = mpims {
            for mpim in mpims {
                let m = Channel(channel: mpim as? [String: AnyObject])
                self.channels[m!.id!] = m
            }
        }
    }
    
    private func enumerateBots(bots: [AnyObject]?) {
        if let bots = bots {
            for bot in bots {
                let b = Bot(bot: bot as? [String: AnyObject])
                self.bots[b!.id!] = b
            }
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
    
    // MARK: - WebSocketDelegate
    public func websocketDidConnect(socket: WebSocket) {
    }
    
    public func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        connected = false
        authenticated = false
        webSocket = nil
        if let delegate = slackEventsDelegate {
            delegate.clientDisconnected()
        }
    }
    
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        guard let data = text.dataUsingEncoding(NSUTF8StringEncoding) else {
            return
        }
        do {
            try EventDispatcher.eventDispatcher(NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject])
        }
        catch _ {
            
        }
    }
    
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
    }
    
}
