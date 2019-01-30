//
// SKRTMAPI.swift
//
// Copyright © 2017 Peter Zignego. All rights reserved.
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

#if os(Linux)
import Dispatch
#endif
import Foundation
import SKWebAPI
@_exported import SKCore

public protocol RTMWebSocket {
    init()
    var delegate: RTMDelegate? { get set }
    func connect(url: URL)
    func disconnect()
    func sendMessage(_ message: String) throws
}

public protocol RTMAdapter: class {
    func initialSetup(json: [String: Any], instance: SKRTMAPI)
    func notificationForEvent(_ event: Event, type: EventType, instance: SKRTMAPI)
    func connectionClosed(with error: Error, instance: SKRTMAPI)
}

public protocol RTMDelegate: class {
    func didConnect()
    func disconnected()
    func receivedMessage(_ message: String)
}

public final class SKRTMAPI: RTMDelegate {

    public var rtm: RTMWebSocket
    public var adapter: RTMAdapter?
    public var token = "xoxp-SLACK_AUTH_TOKEN"
    internal var options: RTMOptions
    public private(set) var connected = false

    var ping: Double?
    var pong: Double?

    public init(withAPIToken token: String, options: RTMOptions = RTMOptions(), rtm: RTMWebSocket? = nil) {
        self.token = token
        self.options = options
        if let rtm = rtm {
            self.rtm = rtm
        } else {
            #if os(Linux)
                self.rtm = VaporEngineRTM()
            #else
                self.rtm = StarscreamRTM()
            #endif
        }
        self.rtm.delegate = self
    }

    public func connect(withInfo: Bool = true) {
        if withInfo {
            WebAPI.rtmStart(
                token: token,
                batchPresenceAware: options.noUnreads,
                mpimAware: options.mpimAware,
                noLatest: options.noLatest,
                noUnreads: options.noUnreads,
                presenceSub: options.presenceSub,
                simpleLatest: options.simpleLatest,
                success: {(response) in
                    self.connectWithResponse(response)
                }, failure: { (error) in
                    self.adapter?.connectionClosed(with: error, instance: self)
                }
            )
        } else {
            WebAPI.rtmConnect(
                token: token,
                batchPresenceAware: options.batchPresenceAware,
                presenceSub: options.presenceSub,
                success: {(response) in
                    self.connectWithResponse(response)
                }, failure: { (error) in
                    self.adapter?.connectionClosed(with: error, instance: self)
                }
            )
        }
    }

    public func disconnect() {
        rtm.disconnect()
    }

    public func sendMessage(_ message: String, channelID: String, id: String? = nil) throws {
        guard connected else {
            throw SlackError.rtmConnectionError
        }
        do {
            let string = try format(message: message, channel: channelID, id: id)
            try rtm.sendMessage(string)
        } catch let error {
            throw error
        }
    }

    public func sendThreadedMessage(_ message: String, channelID: String, threadTs: String, broadcastReply: Bool = false) throws {
        guard connected else {
            throw SlackError.rtmConnectionError
        }
        do {
            let string = try format(message: message, channel: channelID, threadTs: threadTs, broadcastReply: broadcastReply)
            try rtm.sendMessage(string)
        } catch let error {
            throw error
        }
    }

    private func connectWithResponse(_ response: [String: Any]) {
        guard
            let socketURL = response["url"] as? String,
            let url = URL(string: socketURL)
        else {
            return
        }
        self.rtm.connect(url: url)
        self.adapter?.initialSetup(json: response, instance: self)
    }

    private func format(message: String,
                        channel: String,
                        id: String? = nil,
                        threadTs: String? = nil,
                        broadcastReply: Bool = false
    ) throws -> String {
        let json: [String: Any?] = [
            "id": id ?? Date().slackTimestamp,
            "type": "message",
            "channel": channel,
            "text": message,
            "thread_ts": threadTs,
            "broadcastReply": broadcastReply
        ]
        guard
            let data = try? JSONSerialization.data(withJSONObject: filterNilParameters(json), options: []),
            let str = String(data: data, encoding: String.Encoding.utf8)
        else {
            throw SlackError.clientJSONError
        }
        return str
    }

    // MARK: - RTM Ping
    private func pingRTMServer() {
        let pingInterval = Double(UInt64(options.pingInterval * Double(UInt64.nanosecondsPerSecond))) / Double(UInt64.nanosecondsPerSecond)
        let delay = DispatchTime.now() + pingInterval
        DispatchQueue.main.asyncAfter(deadline: delay) {
            guard self.connected && self.isConnectionTimedOut else {
                self.disconnect()
                return
            }
            try? self.sendRTMPing()
            self.pingRTMServer()
        }
    }

    private func sendRTMPing() throws {
        guard connected else {
            throw SlackError.rtmConnectionError
        }
        let json: [String: Any] = [
            "id": Date().slackTimestamp,
            "type": "ping"
        ]
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            throw SlackError.clientJSONError
        }
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            ping = json["id"] as? Double
            try rtm.sendMessage(string)
        }
    }

    var isConnectionTimedOut: Bool {
        if let pong = pong, let ping = ping {
            if pong - ping < options.timeout {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }

    // MARK: RTMDelegate
    public func didConnect() {
        connected = true
        pingRTMServer()
    }

    public func disconnected() {
        connected = false
        if options.reconnect {
            connect()
        } else {
            adapter?.connectionClosed(with: SlackError.rtmConnectionError, instance: self)
        }
    }

    public func receivedMessage(_ message: String) {
        guard let data = message.data(using: String.Encoding.utf8) else {
            return
        }

        if let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] {
            dispatch(json)
        }
    }

    internal func dispatch(_ anEvent: [String: Any]) {
        let event = Event(anEvent)
        let type = event.type ?? .unknown
        switch type {
        case .hello:
            connected = true
        case .pong:
            pong = event.replyTo
        case .teamMigrationStarted:
            connect()
        case .error:
            print("Error: \(anEvent)")
        case .goodbye:
            connect()
        case .unknown:
            print("Unsupported event of type: \(anEvent["type"] ?? "No Type Information")")
        default:
            break
        }
        adapter?.notificationForEvent(event, type: type, instance: self)
    }
}
