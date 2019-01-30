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

public let defaultErrorHandler: (Error) -> (ResponseType) = { err in
    do {
        return try Response(code: 500, body: String(describing: err), headers: HTTPHeaders())
    } catch {}
    return Response(code: 500, body: Data(), headers: HTTPHeaders())
}

extension Titan {
    public func addFunction(errorHandler: @escaping (Error) -> (ResponseType), handler: @escaping ThrowingFunction) {
        self.addFunction(toFunction(handler, errorHandler: errorHandler))
    }
}

public typealias ThrowingFunction = (RequestType, ResponseType) throws -> (RequestType, ResponseType)

/// Convert a throwing function to a non throwing function, calling the specified error handler in case of throws.
public func toFunction(_ handler: @escaping ThrowingFunction, errorHandler: @escaping (Error) -> (ResponseType)) -> TitanFunc {
    return { req, res in
        do {
            return try handler(req, res)
        } catch {
            return (req, errorHandler(error))
        }
    }
}
