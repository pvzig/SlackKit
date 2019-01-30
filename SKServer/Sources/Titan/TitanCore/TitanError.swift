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

public enum TitanError: Error {
    case dataConversion
}

extension TitanError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .dataConversion:
            return "failed converting body String to Data."
        }
    }
    public var failureReason: String? {
        switch self {
        case .dataConversion:
            return "String is not utf8 encoded."
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case .dataConversion:
            return "String must be utf8 encoded."
        }
    }
}
