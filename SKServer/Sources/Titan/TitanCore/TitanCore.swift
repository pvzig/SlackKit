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

public typealias TitanFunc = (RequestType, ResponseType) -> (request: RequestType, response: ResponseType)

public final class Titan {

    public let log: TitanLogger?

    /// Creates a Titan instance
    ///
    /// - parameters:
    ///   - logger: a TitanLogger
    public init(_ logger: TitanLogger? = nil) {
        self.log = logger
    }

    // A chain of Functions that are executed in order. The output of one is the input of the next; the final output is sent to the client.
    private var functionStack = [TitanFunc]()

    /// add a function to Titan’s request / response processing flow
    public func addFunction(_ function: @escaping TitanFunc) {
        functionStack.append(function)
    }

    /// Titan handler which should be given to a server
    public func app(request: RequestType, response: ResponseType) -> (request: RequestType, response: ResponseType) {
        typealias Result = (RequestType, ResponseType)

        let initial: Result = (request, response)
        // Apply the function one at a time to the request and the response, returning the result to the next function.
        return functionStack.reduce(initial) { (res, next) -> Result in
            return next(res.request, res.response)
        }
    }

}
