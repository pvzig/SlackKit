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

public typealias Header = (name: String, value: String)

/// Representation of the HTTP headers associated with a `RequestType` or `ResponseType`.
/// HTTPHeaders are subscritable using case-insensitive comparison.
///
/// Little known fact: HTTP headers need not be unique!
public struct HTTPHeaders {
    private var headers: [Header]

    public init() {
        self.headers = [Header]()
    }

    // Create an HTTPHeaders from an `Header` array.
    public init(headers: [Header]) {
        self.headers = headers
    }

    /// Get the first value associated with the `name` if any.
    public subscript(name: String) -> String? {
        get {
            return self.headers.first { $0.name.lowercased() == name.lowercased()}?.value
        }

        set {
            guard let newValue = newValue else {
                return
            }
            self.headers.append((name, newValue))
        }
    }

    /// Remove all the headers with the `name`.
    public mutating func removeHeaders(name: String) {
        self.headers = headers.filter({ (key, _) -> Bool in
            return key.lowercased() != name.lowercased()
        })
    }

    public var count: Int {
        return self.headers.count
    }
}

extension HTTPHeaders: Sequence {
    public typealias Iteraror = DictionaryIterator<String, String>

    public func makeIterator() -> AnyIterator<Header> {
      var iterator = headers.makeIterator()

        return AnyIterator {
            return iterator.next()
        }
    }

}

extension HTTPHeaders: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: (String, String)...) {
        self.init()
        for (key, value) in elements {
            self.headers.append((key, value))
        }

    }
}

/// Joins two headers, overwriting the `key` and `value` in the `lhs` with `rhs`.
public func + (lhs: HTTPHeaders, rhs: HTTPHeaders) -> HTTPHeaders {
    var lhs = lhs

    for (key, value) in rhs {
        lhs[key] = value
    }

    return lhs
}
