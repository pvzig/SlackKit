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

extension Request {
    public init(_ method: HTTPMethod = .get, _ path: String = "/", _ queryPairs: [(String, String)] = [], _ body: String = "", _ headers: HTTPHeaders = HTTPHeaders()) {
        self.init(method: method, path: path, queryPairs: queryPairs, body: body.data(using: .utf8) ?? Data(), headers: headers)
    }
}

extension Response {
    public init(_ code: Int = 200, _ body: String, _ headers: HTTPHeaders = HTTPHeaders()) throws {
        try self.init(code: code, body: body, headers: headers)
    }

    public init(_ code: Int = 200, _ body: Data = Data(), _ headers: HTTPHeaders = HTTPHeaders()) {
        self.init(code: code, body: body, headers: headers)
    }
}
