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

/// A basic healthcheck route that returns 200 and diagnostic info
public let healthz: TitanFunc = healthzWithCheck(check: { return nil })

// Workaround for https://bugs.swift.org/browse/SR-6391
let cachedHostname: String = {
    return ProcessInfo.processInfo.hostName
}()

/// Creates a healthcheck route that executes the supplied closure.
/// If a string is returned, the string is returned as part of the diagnostic info in the
/// healthcheck 200 response.
/// If an error is thrown, the error is coerced to a string and printed inside a 500 response.
public func healthzWithCheck(check: @escaping () throws -> String?) -> TitanFunc {
    return { req, res in

        guard req.path.lowercased() == "/healthz",
            req.method == .get else {
                return (req, res)
        }

        do {
            let result = try check() ?? "Ok"
            let ok = try Response(code: 200,
                                  body: "Host: \(cachedHostname)\nTime: \(Date())\n\nStatus: \(result)",
                headers: HTTPHeaders())
            return (req, ok)
        } catch {
            let body = "Host: \(cachedHostname)\nTime: \(Date())\n\nStatus: \(error)".data(using: .utf8) ?? Data()
            let notOk = Response(code: 500, body: body, headers: HTTPHeaders())
            return (req, notOk)
        }
    }
}
