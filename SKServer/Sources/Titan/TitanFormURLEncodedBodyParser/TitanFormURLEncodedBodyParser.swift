import Foundation

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
public extension RequestType {

    public var formURLEncodedBody: [(name: String, value: String)] {
        guard let bodyString: String = self.body else {
            return []
        }

        return parse(body: bodyString)
    }

    public var postParams: [String: String] {
        var ret = [String: String]()
        guard let bodyString: String = self.body else {
            return ret
        }
        let keys = parse(body: bodyString)
        for (k, v) in keys {
            ret[k] = v
        }
        return ret
    }
}

/*
 Parse application/x-www-form-urlencoded bodies
 Returns as many name-value pairs as possible
 Liberal in what it accepts, any failures to delimit pairs or decode percent
 encoding will result in empty strings
 */
func parse(body: String) -> [(name: String, value: String)] {
    var retValue = [(name: String, value: String)]()

    let pairs = body.components(separatedBy: "&") // Separate the tuples

    for element in pairs {
        // Find the equals sign
        guard let range = element.range(of: "=") else {
            return retValue
        }
        // split out the key and the value
        let rawKey = element[..<range.lowerBound]
        let rawValue = element[range.upperBound...]

        // Remove + character
        let sanitizedKey = String(rawKey).replacingOccurrences(of: "+", with: " ")
        let sanitizedValue = String(rawValue).replacingOccurrences(of: "+", with: " ")

        let key = sanitizedKey.removingPercentEncoding ?? sanitizedKey
        let value = sanitizedValue.removingPercentEncoding ?? sanitizedValue

        retValue.append((key, value))
    }
    return retValue
}
