//   Copyright 2017 Enervolution GmbH
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
import Foundation

/// A protocol defining an HTTP request
public protocol RequestType {
    /// The HTTP request body.
    var body: Data { get }
    /// The HTTP request path
    var path: String { get }
    /// The HTTP request query pairs
    var queryPairs: [(String, String)] { get }
    /// The HTTP request method.
    var method: HTTPMethod { get }
    /// The HTTP request headers.
    var headers: HTTPHeaders { get }
}

/// A reified `RequestType`
public struct Request: RequestType {

    public var method: HTTPMethod
    public var path: String
    public var queryPairs: [(String, String)]
    public var body: Data
    public var headers: HTTPHeaders

    /// Create a Request
    /// Throws an error if the body parameter cannot be converted to Data
    public init(method: HTTPMethod, path: String, queryPairs: [(String, String)], body: String, headers: HTTPHeaders) throws {
        self.method = method
        self.path = path
        self.queryPairs = queryPairs
        guard let data = body.data(using: .utf8) else {
            throw TitanError.dataConversion
        }
        self.body = data
        self.headers = headers
    }

    /// Create a Request
    public init(method: HTTPMethod, path: String, queryPairs: [(String, String)], body: Data, headers: HTTPHeaders) {
        self.method = method
        self.path = path
        self.queryPairs = queryPairs
        self.body = body
        self.headers = headers
    }
}

extension Request {
    /// Create a Request from a RequestType
    public init(request: RequestType) {
        self.init(method: request.method, path: request.path, queryPairs: request.queryPairs, body: request.body, headers: request.headers)
    }
}

extension RequestType {
    /// The HTTP request body as a UTF-8 encoded string.
    public var body: String? {
        return String(data: self.body, encoding: .utf8)
    }

    /// Create a Request as a copy of the RequestType
    public func copy() -> Request {
        return Request(request: self)
    }
}
