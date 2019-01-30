//
// MessageActionMiddleware.swift
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

public struct MessageActionMiddleware: Middleware {
    let token: String
    let routes: [MessageActionRoute]

    public init(token: String, routes: [MessageActionRoute]) {
        self.token = token
        self.routes = routes
    }

    public func respond(to request: (RequestType, ResponseType)) -> (RequestType, ResponseType) {
        if let form = request.0.formURLEncodedBody.first(where: {$0.name == "ssl_check"}), form.value == "1" {
            return (request.0, Response(200))
        }
        guard
            let actionRequest = MessageActionRequest(request: request.0),
            let middleware = routes.first(where: {$0.action.name == actionRequest.action?.name})?.middleware,
            actionRequest.token == token
        else {
            return (request.0, Response(400))
        }
        return middleware.respond(to: request)
    }
}
