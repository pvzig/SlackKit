//
// SlackKit.swift
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

import Foundation
@_exported import SKClient
@_exported import SKCore
@_exported import SKRTMAPI
@_exported import SKServer
@_exported import SKWebAPI

public final class SlackKit: RTMAdapter {

    public typealias EventClosure = (Event, ClientConnection?) -> Void
    internal typealias TypedEvent = (EventType, EventClosure)
    internal var callbacks = [TypedEvent]()
    internal(set) public var server: SKServer?
    internal(set) public var clients: [String: ClientConnection] = [:]

    /// Return the `SKRTMAPI` instance of the first client
    public var rtm: SKRTMAPI? {
        return clients.values.first?.rtm
    }
    /// Return the `WebAPI` instance of the first client
    public var webAPI: WebAPI? {
        return clients.values.first?.webAPI
    }

    public init() {}

    public func addWebAPIAccessWithToken(_ token: String) {
        let webAPI = WebAPI(token: token)
        if let clientConnection = clients[token] {
            clientConnection.webAPI = webAPI
        } else {
            clients[token] = ClientConnection(client: nil, rtm: nil, webAPI: webAPI)
        }
    }

    public func addRTMBotWithAPIToken(
        _ token: String,
        client: Client? = Client(),
        options: RTMOptions = RTMOptions(),
        rtm: RTMWebSocket? = nil
    ) {
        let rtm = SKRTMAPI(withAPIToken: token, options: options, rtm: rtm)
        rtm.adapter = self

        if let clientConnection = clients[token] {
            clientConnection.rtm = rtm
        } else {
            clients[token] = ClientConnection(client: client, rtm: rtm, webAPI: nil)
        }
        clients[token]?.rtm?.connect()
    }

    public func addServer(_ server: SlackKitServer? = nil, responder: SlackKitResponder? = nil, oauth: OAuthConfig? = nil) {
        var responder: SlackKitResponder = responder ?? SlackKitResponder(routes: [])
        if let oauth = oauth {
            responder.routes.append(oauthRequestRoute(config: oauth))
        }
        self.server = SKServer(server: server, responder: responder)
        self.server?.start()
    }

    private func oauthRequestRoute(config: OAuthConfig) -> RequestRoute {
        let oauth = OAuthMiddleware(config: config) { authorization in
            // User
            if let token = authorization.accessToken {
                self.addWebAPIAccessWithToken(token)
            }
            // Bot User
            if let token = authorization.bot?.botToken {
                self.addRTMBotWithAPIToken(token)
            }
        }
        return RequestRoute(path: "/oauth", middleware: oauth)
    }

    // MARK: - RTM Adapter
    public func initialSetup(json: [String: Any], instance: SKRTMAPI) {
        clients[instance.token]?.client?.initialSetup(JSON: json)
    }

    public func notificationForEvent(_ event: Event, type: EventType, instance: SKRTMAPI) {
        let clientConnection = clients[instance.token]
        clientConnection?.client?.notificationForEvent(event, type: type)
        executeCallbackForEvent(event, type: type, clientConnection: clientConnection)
    }

    public func connectionClosed(with error: Error, instance: SKRTMAPI) {}

    // MARK: - Callbacks
    public func notificationForEvent(_ type: EventType, event: @escaping EventClosure) {
        callbacks.append((type, event))
    }

    private func executeCallbackForEvent(_ event: Event, type: EventType, clientConnection: ClientConnection?) {
        let cbs = callbacks.filter {$0.0 == type}
        for callback in cbs {
            callback.1(event, clientConnection)
        }
    }
}
