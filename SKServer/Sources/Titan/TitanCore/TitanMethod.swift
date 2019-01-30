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

/// An enumeration of available HTTP Request Methods
public indirect enum HTTPMethod: Equatable {
    case get
    case head
    case put
    case post
    case patch
    case delete
    case trace
    case options
    case custom(named: String)

    public static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        switch (lhs, rhs) {
        case (.get, .get):
            return true
        case (.head, .head):
            return true
        case (.put, .put):
            return true
        case (.post, .post):
            return true
        case (.patch, .patch):
            return true
        case (.delete, .delete):
            return true
        case (.trace, .trace):
            return true
        case (.options, .options):
            return true
        case (.custom(let a), .custom(let b)):
            return a == b
        default:
            return false
        }
    }
}

extension HTTPMethod: RawRepresentable {

    public typealias RawValue = String

    public init?(rawValue: String) {
        switch rawValue.lowercased() {
        case "get":
            self = .get
        case "head":
            self = .head
        case "put":
            self = .put
        case "post":
            self = .post
        case "patch":
            self = .patch
        case "delete":
            self = .delete
        case "trace":
            self = .trace
        case "options":
            self = .options
        default :
            self = .custom(named: rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .get:
            return "get"
        case .head:
            return "head"
        case .put:
            return "put"
        case .post:
            return "post"
        case .patch:
            return "patch"
        case .delete:
            return "delete"
        case .trace:
            return "trace"
        case .options:
            return "options"
        case .custom(let named):
            return named
        }
    }
}
