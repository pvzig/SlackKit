//
//  SwifterServer.swift
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
import Swifter

class SwifterServer: SlackKitServer {
    let server = HttpServer()
    let port: in_port_t
    let forceIPV4: Bool

    init(port: in_port_t = 8080, forceIPV4: Bool = false, responder: SlackKitResponder) {
        self.port = port
        self.forceIPV4 = forceIPV4

        for route in responder.routes {
            server[route.path] = { request in
                return route.middleware.respond(to: (request.request, Response())).1.httpResponse
            }
        }
    }

    public func start() {
        do {
            try server.start(port, forceIPv4: forceIPV4)
        } catch let error {
            print("Server failed to start with error: \(error)")
        }
    }

    deinit {
        server.stop()
    }
}

extension HttpRequest {
    public var request: RequestType {
        return try! Request(
            method: HTTPMethod.custom(named: method),
            path: path,
            queryPairs: queryParams,
            body: String(bytes: body, encoding: .utf8) ?? "",
            headers: HTTPHeaders(headers: headers.map ({ Header(name: $0.key, value: $0.value) }))
        )
    }
}

extension ResponseType {
    public var contentType: String? {
        return self.headers.first(where: {$0.name.lowercased() == "content-type"})?.value
    }

    public var httpResponse: HttpResponse {
        switch self.code {
        case 200 where contentType == nil:
            return .ok(.text(bodyString ?? ""))
        case 200 where contentType?.lowercased() == "application/json":
            do {
                let json = try JSONSerialization.jsonObject(with: body, options: [])
                #if os(Linux)
                    //swiftlint:disable force_cast
                    return .ok(.json(json as! AnyObject))
                    //swiftlint:enable force_cast
                #else
                    return .ok(.json(json as AnyObject))
                #endif
            } catch let error {
                return .badRequest(.text(error.localizedDescription))
            }
        case 400:
            return .badRequest(.text("Bad request."))
        default:
            return .ok(.text("ok"))
        }
    }
}
