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

extension Titan {
    public func predicate(_ predicate: @escaping (RequestType, ResponseType) -> Bool,
                          true trueBuilder: ((Titan) -> Void), false falseBuilder: ((Titan) -> Void)? = nil) {

        let trueTitan = Titan()
        trueBuilder(trueTitan)
        let falseTitan = falseBuilder.map { (builder) -> Titan in
            let falseTitan = Titan()
            builder(falseTitan)
            return falseTitan
        }
        self.addFunction { (req, res) -> (RequestType, ResponseType) in
            if predicate(req, res) {
                return trueTitan.app(request: req, response: res)
            } else {
                return falseTitan?.app(request: req, response: res) ?? (req, res)
            }
        }
    }

    public func authenticated(_ predicate: @escaping ((RequestType) -> Bool), _ authenticatedBuilder: ((Titan) -> Void)) {
        self.predicate({ (req, _) -> Bool in
            return predicate(req)
        }, true: authenticatedBuilder, false: { (unauthenticated) in
            unauthenticated.addFunction({ (req, _) -> (RequestType, ResponseType) in
                do {
                    return (req,
                            try Response(code: 401, body: "Not Authorized",
                                         headers: HTTPHeaders(dictionaryLiteral: ("Content-Type", "text/plain"))))
                } catch {
                    self.log?.error(error.localizedDescription)
                }
                return (req, Response(401))
            })
        })
    }
}
