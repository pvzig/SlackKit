//
// SlackKit.swift
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

public final class SlackKit: OAuthDelegate {
    
    internal(set) public var oauth: OAuthServer?
    internal(set) public var clients: [String: Client] = [:]
    private let clientOptions: ClientOptions

    // Initialization block
    public var onClientInitialization: ((Client) -> Void)?

    @available(*, deprecated=2.0, renamed="onClientInitialization")
    public var onClientInitalization: ((Client) -> Void)? {
        set {
            onClientInitialization = newValue
        }
        get {
            return onClientInitialization
        }
    }

    // If you already have an API token
    public init(withAPIToken token: String, clientOptions: ClientOptions = ClientOptions()) {
        self.clientOptions = clientOptions
        let client = Client(apiToken: token)
        dispatch_async(dispatch_get_main_queue(), {
            self.onClientInitalization?(client)
        })
        clients[token] = client
        client.connect(options: self.clientOptions)
    }
    
    // If you're going to be receiving and/or initiating OAuth requests, provide a client ID and secret
    public init(clientID: String, clientSecret: String, state: String? = nil, redirectURI: String? = nil, port:in_port_t = 8080, forceIPV4: Bool = false, clientOptions: ClientOptions = ClientOptions()) {
        self.clientOptions = clientOptions
        oauth = try? OAuthServer(clientID: clientID, clientSecret: clientSecret, state: state, redirectURI: redirectURI, port: port, forceIPV4: forceIPV4, delegate: self)
    }
    
    internal func userAuthed(response: OAuthResponse) {
        // User auth
        if let token = response.accessToken {
            let client = Client(apiToken: token)
            self.onClientInitalization?(client)
            clients[token] = client
        }
        // Bot User
        if let token = response.bot?.botToken {
            let client = Client(apiToken: token)
            self.onClientInitalization?(client)
            clients[token] = client
            client.connect(options: self.clientOptions)
        }
    }
    
}
