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

/*
 Returns a 404 response.

 By design, Titan returns a null HTTP response. This is less than ideal.
 by adding this to the top of a chain of Titan functions, the server will return this response if
 no other function has returned a ResponseType. Otherwise, any other function that returns a response will
 effectively overwrite it.
 */
public let defaultTo404: TitanFunc = { (request, response) -> (RequestType, ResponseType) in

    do {
        return (request, try Response(code: 404, body: "Not found", headers: HTTPHeaders(dictionaryLiteral: ("Content-Type", "text/plain"))))
    } catch {
        return (request, Response(code: 404, body: Data(), headers: HTTPHeaders()))
    }
}
