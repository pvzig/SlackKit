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

/// A protocol defining an HTTP response
public protocol ResponseType {
    /// The HTTP response status code.
    var code: Int { get }
    /// The HTTP response headers.
    var headers: HTTPHeaders { get }
    /// The HTTP response body.
    var body: Data { get }
}

/// A reified `ResponseType`
public struct Response: ResponseType {
    public var code: Int
    public var headers: HTTPHeaders
    public var body: Data

    /// Create a Response
    public init(code: Int, body: Data?, headers: HTTPHeaders = HTTPHeaders()) {
        self.code = code
        self.body = body ?? Data()
        self.headers = headers
    }

    /// Create a Response
    /// Throws an error if the body parameter cannot be converted to Data
    public init(code: Int, body: String, headers: HTTPHeaders) throws {

        self.code = code
        guard let data = body.data(using: .utf8) else {
            throw TitanError.dataConversion
        }
        self.body = data
        self.headers = headers
    }
}

extension Response {
    /// Create a Response from a ResponseType
    public init(response: ResponseType) {
        self.init(code: response.code, body: response.body, headers: response.headers)
    }
}

extension ResponseType {
    /// The HTTP response body as a UTF-8 encoded string.
    public var bodyString: String? {
        return String(data: self.body, encoding: .utf8)
    }
    /// Create a Response as a copy of the ResponseType
    public func copy() -> Response {
        return Response(response: self)
    }
}
