//
//  VaporEngineRTM.swift
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
import Foundation
import Sockets
import HTTP
import TLS
import URI
import WebSockets

public class VaporEngineRTM: RTMWebSocket {
    public weak var delegate: RTMDelegate?

    public required init() {}

    private var websocket: WebSocket?

    public func connect(url: URL) {

        let headers: [HeaderKey: String] = [:]
        let protocols: [String]? = nil
        do {
            let uri = try URI(url.absoluteString)
            if uri.scheme.isSecure {
                let tcp = try TCPInternetSocket(
                    scheme: "https",
                    hostname: uri.hostname,
                    port: uri.port ?? 443
                )
                let stream = try TLS.InternetSocket(tcp, TLS.Context(.client))
                try WebSocket.background(
                    to: uri,
                    using: stream,
                    protocols: protocols,
                    headers: headers,
                    onConnect: didConnect
                )
            } else {
                let stream = try TCPInternetSocket(
                    scheme: "http",
                    hostname: uri.hostname,
                    port: uri.port ?? 80
                )
                try WebSocket.background(
                    to: uri,
                    using: stream,
                    protocols: protocols,
                    headers: headers,
                    onConnect: didConnect
                )
            }
        } catch {
            print("Error connecting to \(url.absoluteString): \(error)")
        }
    }

    func didConnect(websocket: WebSocket) throws {
        self.websocket = websocket

        self.delegate?.didConnect()

        websocket.onText = { ws, text in
            self.delegate?.receivedMessage(text)
        }

        websocket.onClose = { ws, _, _, close in
            self.delegate?.disconnected()
        }

        websocket.onPing = { ws, data in
            try ws.pong(data)
        }

        websocket.onPong = { ws, data in
            try ws.ping(data)
        }
    }

    public func disconnect() {
        do {
            try self.websocket?.close()
        } catch {
            print("Error disconnecting from \(self.websocket.debugDescription): \(error)")
        }
    }

    public func sendMessage(_ message: String) throws {
        guard let websocket = websocket else { throw SlackError.rtmConnectionError }
        try websocket.send(message)
    }
}
#endif
