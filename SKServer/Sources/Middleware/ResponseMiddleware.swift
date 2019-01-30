//
// ResponseMiddleware.swift
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

public struct ResponseMiddleware: Middleware {
    let token: String
    let response: SKResponse

    public init(token: String, response: SKResponse) {
        self.token = token
        self.response = response
    }

    public func respond(to request: (RequestType, ResponseType)) -> (RequestType, ResponseType) {
        if let respondable = Respondable(request: request.0), respondable.token == token {
            return (request.0, Response(response: response))
        }
        return (request.0, Response(400))
    }

    private struct Respondable {
        let token: String

        init?(request: RequestType) {
            if let webhook = WebhookRequest(request: request), let token = webhook.token {
                self.token = token
            } else if let action = MessageActionRequest(request: request), let token = action.token {
                self.token = token
            } else {
                return nil
            }
        }
    }
}

extension WebhookRequest {
    public init?(request: RequestType) {
        guard
            let proto = request.headers.first(where: {$0.name.lowercased() == "x-forwarded-proto"})?.value,
            let host = request.headers.first(where: {$0.name.lowercased() == "host"})?.value
        else {
            return nil
        }
        let requestString = proto + host + request.path + "?" + request.body!
        let components = URLComponents(string: requestString)
        var dict = [String: Any]()
        _ = components?.queryItems.flatMap {$0.map({dict[$0.name]=$0.value})}
        self.init(request: dict)
    }
}

extension MessageActionRequest {
    public init?(request: RequestType) {
        guard
            let response = request.formURLEncodedBody.first(where: {$0.name.lowercased() == "payload" })?.value,
            let data = response.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            else {
                return nil
        }
        self.init(response: json)
    }
}

extension Response {
    public init(response: SKResponse) {
        if response.attachments == nil {
            try! self.init(200, response.text)
        } else if
        let data = try? JSONSerialization.data(withJSONObject: response.json, options: []),
        let body = String(data: data, encoding: .utf8) {
            try! self.init(code: 200, body: body, headers: HTTPHeaders(headers: [Header(name: "content-type", value: "application/json")]))
        } else {
            self.init(400)
        }
    }
}
