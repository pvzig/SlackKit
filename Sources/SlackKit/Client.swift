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
import Venice
import WebSocketClient

public class SlackClient {
    
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
    
    internal var token = "SLACK_AUTH_TOKEN"
    
    public func setAuthToken(token: String) {
        self.token = token
    }
    
    public var webAPI: SlackWebAPI {
        return SlackWebAPI(token: token)
    }

    internal var client: WebSocketClient?
    internal var socket: WebSocket?
    
    internal var ping: Double?
    internal var pong: Double?
    internal var pingInterval: Double = 30
    internal var timeout: Double = 300
    internal var reconnect: Bool = false
    
    required public init(apiToken: String) {
        self.token = apiToken
    }
    
    public func connect(simpleLatest: Bool? = nil, noUnreads: Bool? = nil, mpimAware: Bool? = nil, pingInterval: Double = 30, timeout: Double = 300, reconnect: Bool = false) {
        self.pingInterval = pingInterval
        self.timeout = timeout
        self.reconnect = reconnect
        webAPI.rtmStart(simpleLatest: simpleLatest, noUnreads: noUnreads, mpimAware: mpimAware, success: { (response) in
            self.initialSetup(JSON: response)
            if let socketURL = response["url"] as? String, let url = URL(string: socketURL) {
                do {
                    self.client = try WebSocketClient(url: url, didConnect: { (socket) in
                        self.setupSocket(socket)
                    })
                    try self.client?.connect()
                } catch let error {
                    print("WebSocket client could not connect: \(error)")
                }
            }
        }, failure: {(error) in
            print("rtm.start failed with error: \(error)")
        })
    }
    
    public func disconnect() {
        _ = try? socket?.close()
    }
    
    //MARK: - RTM message send
    public func sendMessage(message: String, channelID: String) {
        if connected {
            if let data = formatMessageToSlackJsonString(message: message, channel: channelID) {
                do {
                    try socket?.send(data.base64EncodedString())
                } catch let error {
                    print("Message failed to send: \(error)")
                }
            }
        }
    }
    
    private func formatMessageToSlackJsonString(message: String, channel: String) -> Data? {
        let json: [String: Any] = [
            "id": Date().slackTimestamp,
            "type": "message",
            "channel": channel,
            "text": message.slackFormatEscaping
        ]
        
        do {
            return try JSONSerialization.data(withJSONObject: json, options: [])
        } catch {
            return nil
        }
    }
    
    private func addSentMessage(_ dictionary: [String: Any]) {
        var message = dictionary
        guard let id = message["id"] as? NSNumber else {
            return
        }
        let ts = String(describing: id)
        message.removeValue(forKey: "id")
        message["ts"] = ts
        message["user"] = self.authenticatedUser?.id
        sentMessages[ts] = Message(dictionary: message)
    }
    
    //MARK: - Client setup
    private func initialSetup(JSON: [String: Any]) {
        team = Team(team: JSON["team"] as? [String: Any])
        authenticatedUser = User(user: JSON["self"] as? [String: Any])
        authenticatedUser?.doNotDisturbStatus = DoNotDisturbStatus(status: JSON["dnd"] as? [String: Any])
        enumerateObjects(JSON["users"] as? Array) { (user) in self.addUser(user) }
        enumerateObjects(JSON["channels"] as? Array) { (channel) in self.addChannel(channel) }
        enumerateObjects(JSON["groups"] as? Array) { (group) in self.addChannel(group) }
        enumerateObjects(JSON["mpims"] as? Array) { (mpim) in self.addChannel(mpim) }
        enumerateObjects(JSON["ims"] as? Array) { (ims) in self.addChannel(ims) }
        enumerateObjects(JSON["bots"] as? Array) { (bots) in self.addBot(bots) }
        enumerateSubteams(JSON["subteams"] as? [String: Any])
    }
    
    private func addUser(_ aUser: [String: Any]) {
        let user = User(user: aUser)
        if let id = user.id {
            users[id] = user
        }
    }
    
    private func addChannel(_ aChannel: [String: Any]) {
        let channel = Channel(channel: aChannel)
        if let id = channel.id {
            channels[id] = channel
        }
    }
    
    private func addBot(_ aBot: [String: Any]) {
        let bot = Bot(bot: aBot)
        if let id = bot.id {
            bots[id] = bot
        }
    }
    
    private func enumerateSubteams(_ subteams: [String: Any]?) {
        if let subteams = subteams {
            if let all = subteams["all"] as? [[String: Any]] {
                for item in all {
                    let u = UserGroup(userGroup: item)
                    if let id = u.id {
                        self.userGroups[id] = u
                    }
                }
            }
            if let auth = subteams["self"] as? [String] {
                for item in auth {
                    authenticatedUser?.userGroups = [String: String]()
                    authenticatedUser?.userGroups?[item] = item
                }
            }
        }
    }
    
    // MARK: - Utilities
    private func enumerateObjects(_ array: [Any]?, initalizer: ([String: Any])-> Void) {
        if let array = array {
            for object in array {
                if let dictionary = object as? [String: Any] {
                    initalizer(dictionary)
                }
            }
        }
    }
    
    //MARK: - RTM Ping
    internal func pingRTMServer() {
        co {
            self.sendRTMPing()
            nap(for: self.pingInterval.seconds)
            guard self.connected && self.isConnectionTimedOut else {
                self.disconnect()
                return
            }
            self.pingRTMServer()
        }
    }
    
    private func sendRTMPing() {
        guard connected else {
            return
        }
        let json: [String: Any] = [
            "id": Date().slackTimestamp,
            "type": "ping"
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return
        }
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            ping = json["id"] as? Double
            do {
                try socket?.send(string)
            } catch let error {
                print("Failed to send ping with error: \(error)")
            }
        }
    }
    
    var isConnectionTimedOut: Bool {
        if let pong = pong, let ping = ping {
            if pong - ping < timeout {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    // MARK: - WebSocket
    private func setupSocket(_ socket: WebSocket) {
        socket.onText {(message) in
            self.websocketDidReceive(message: message)
        }
        socket.onClose{ (code: CloseCode?, reason: String?) in
            self.websocketDidDisconnect(closeCode: code, error: reason)
        }
        socket.onPing { (data) in try socket.pong() }
        socket.onPong { (data) in try socket.ping() }
        self.socket = socket
    }
    
    private func websocketDidReceive(message: String) {
        do {
            guard let message = message.data(using: .utf8) else {
                print("Failed to decode message")
                return
            }
            let json = try JSONSerialization.jsonObject(with: message, options: [])
            if let event = json as? [String: Any] {
                dispatch(event)
            }
        }
        catch let error {
            print("Failed to dispatch message: \(error)")
        }
    }
    
    private func websocketDidDisconnect(closeCode: CloseCode?, error: String?) {
        connected = false
        authenticated = false
        client = nil
        socket = nil
        authenticatedUser = nil
        connectionEventsDelegate?.disconnected(self)
        if reconnect == true {
            connect(pingInterval: pingInterval, timeout: timeout, reconnect: reconnect)
        }
    }
}
