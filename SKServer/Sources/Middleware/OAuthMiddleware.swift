//
// OAuthMiddleware.swift
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

import SKCore
import SKWebAPI

public struct OAuthMiddleware: Middleware {
    private let config: OAuthConfig
    internal(set) public var authed: ((OAuthResponse) -> Void)?

    public init(config: OAuthConfig, authed: ((OAuthResponse) -> Void)? = nil) {
        self.config = config
        self.authed = authed
    }

    public func respond(to request: (RequestType, ResponseType)) -> (RequestType, ResponseType) {
        guard let response = AuthorizeResponse(queryItems: request.0.query), let code = response.code, response.state == config.state else {
            return (request.0, Response(400))
        }
        let authResponse = WebAPI.oauthAccess(
            clientID: config.clientID,
            clientSecret: config.clientSecret,
            code: code,
            redirectURI: config.redirectURI
        )
        self.authed?(OAuthResponse(response: authResponse))
        guard let redirect = config.redirectURI else {
            return (request.0, Response(200))
        }
        return (request.0, try! Response(code: 302, body: "", headers: HTTPHeaders(headers: [Header(name: "location", value: redirect)])))
    }
}
