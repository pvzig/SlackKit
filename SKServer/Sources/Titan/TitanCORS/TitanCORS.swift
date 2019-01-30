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

/// Allow this app to be accessed with total violation of Same Origin Policy.
/// This adds the `AllowAllOrigins` and `RespondToPreflightAllowingAllMethods` functions.
public func addInsecureCORSSupport(_ titan: Titan) {
    titan.addFunction(respondToPreflightAllowingAllMethods)
    titan.addFunction(allowAllOrigins)
}

/// A header that allows all origins. You probably want to use the `AllowAllOrigins` Function instead
public let allowAllOriginsHeader: Header = ("access-control-allow-origin", "*")

/// If one isn't present, insert a wildcard CORS allowed origin header
public let allowAllOrigins: TitanFunc = { req, res in
    var allowAllOriginHeaders = HTTPHeaders(dictionaryLiteral: allowAllOriginsHeader)
    // swiftlint:disable shorthand_operator
    allowAllOriginHeaders = allowAllOriginHeaders + res.headers
    // swiftlint:enable shorthand_operator
    return (req, Response(code: res.code, body: res.body, headers: allowAllOriginHeaders))
}

/// Respond to a CORS preflight request, allowing all methods requested in the preflight.
public let respondToPreflightAllowingAllMethods: TitanFunc = { req, res in
    guard req.method == .options else {
        return (req, res)
    }
    guard let requestedMethods = (req.headers.first(where: { (name, _) -> Bool in
        return name.lowercased() == "access-control-request-method"
    }).map { (header: Header) -> String in
        return header.value
    }) else {
        return (req, res)
    }
    var headers: [Header] = []
    headers.append(("access-control-allow-methods", requestedMethods))
    if let requestedHeaders = (req.headers.first(where: { (name, _) -> Bool in
        return name.lowercased() == "access-control-request-headers"
    }).map { (header: Header) -> String in
        return header.value
    }) {
        headers.append(("access-control-allow-headers", requestedHeaders))
    } else {
        headers.append(("access-control-allow-headers", "*"))
    }
    return (req, Response(code: 200, body: Data(), headers: HTTPHeaders(headers: headers)))
}
