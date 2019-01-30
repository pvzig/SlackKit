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

public extension Response {

    public init(code: Int, json: Any) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        self.init(code: code, body: jsonData, headers: HTTPHeaders(dictionaryLiteral: ("content-type", "application/json")))
    }

    public init<T: Encodable>(code: Int, object: T, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        let data = try jsonEncoder.encode(object)
        self.init(code: code, body: data, headers: HTTPHeaders(dictionaryLiteral: ("content-type", "application/json")))
    }
}
