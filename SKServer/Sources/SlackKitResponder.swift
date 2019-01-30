//
// SlackKitResponder.swift
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

//swiftlint:disable line_length
public struct SlackKitResponder: Middleware {

    public var routes: [RequestRoute]

    public init(routes: [RequestRoute]) {
        self.routes = routes
    }

    public func respond(to request: (RequestType, ResponseType)) -> (RequestType, ResponseType) {
        if let form = request.0.formURLEncodedBody.first(where: {$0.name == "ssl_check"}), form.value == "1" {
            return (request.0, Response(200))
        }
        return routes.filter { $0.path == request.0.path }.first?.middleware.respond(to: (request.0, request.1)) ?? (request.0, Response(404))
    }
}
