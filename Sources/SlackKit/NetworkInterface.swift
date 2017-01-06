//
// NetworkInterface.swift
//
// Copyright © 2016 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import HTTPClient
import WebSocketClient

internal struct NetworkInterface {
    
    private let apiUrl = "https://slack.com/api/"
    private let client: HTTPClient.Client?
    
    init() {
        do {
            self.client = try Client(url: URL(string: "https://slack.com")!)
        } catch {
            self.client = nil
        }
    }
    
    internal func request(_ endpoint: Endpoint, parameters: [String: Any?], successClosure: @escaping ([String: Any])->Void, errorClosure: @escaping (SlackError)->Void) {
        var components = URLComponents(string: "\(apiUrl)\(endpoint.rawValue)")
        if parameters.count > 0 {
            components?.queryItems = filterNilParameters(parameters).map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        }
        guard let requestString = components?.string else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        
        do {
            let contentNegotiation = ContentNegotiationMiddleware(mediaTypes: [.json, .urlEncodedForm], mode: .client)
            let response = try client?.get(requestString, middleware: [contentNegotiation])
            successClosure(try handleResponse(response))
        } catch let error {
            if let slackError = error as? SlackError {
                errorClosure(slackError)
            } else {
                errorClosure(SlackError.unknownError)
            }
        }
    }
    
    internal func uploadRequest(data: Data, parameters: [String: Any?], successClosure: @escaping ([String: Any])->Void, errorClosure: @escaping (SlackError)->Void) {
        var components = URLComponents(string: "\(apiUrl)\(Endpoint.filesUpload.rawValue)")
        if parameters.count > 0 {
            components?.queryItems = filterNilParameters(parameters).map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        }
        guard let requestString = components?.string else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
    
        let boundaryConstant = randomBoundary()
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "\r\n--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(parameters["filename"])\"\r\n"
        let contentTypeString = "Content-Type: \(parameters["filetype"])\r\n\r\n"
        
        guard let boundaryStartData = boundaryStart.data(using: .utf8), let dispositionData = contentDispositionString.data(using: .utf8), let contentTypeData = contentTypeString.data(using: .utf8), let boundaryEndData = boundaryEnd.data(using: .utf8) else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        var requestBodyData = Data()
        requestBodyData.append(contentsOf: boundaryStartData)
        requestBodyData.append(contentsOf: dispositionData)
        requestBodyData.append(contentsOf: contentTypeData)
        requestBodyData.append(contentsOf: data)
        requestBodyData.append(contentsOf: boundaryEndData)
        
        let header: Headers = ["Content-Type":"multipart/form-data; boundary=\(boundaryConstant)"]
        let body = Buffer([UInt8](requestBodyData))

        do {
            let response = try client?.post(requestString, headers: header, body: body)
            successClosure(try handleResponse(response))
        } catch let error {
            if let slackError = error as? SlackError {
                errorClosure(slackError)
            } else {
                errorClosure(SlackError.unknownError)
            }
        }
    }
    
    private func handleResponse(_ response: Response?) throws -> [String: Any] {
        guard var response = response else {
            throw SlackError.clientNetworkError
        }
        do {
            let buffer = try response.body.becomeBuffer(deadline: 3.seconds.fromNow())
            switch response.statusCode {
            case 200:
                let data = Data(bytes: buffer.bytes)
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    if json["ok"] as? Bool == true {
                        return json
                    } else if let errorString = json["error"] as? String {
                        throw SlackError(rawValue: errorString) ?? .unknownError
                    } else {
                        throw SlackError.clientJSONError
                    }
                } else {
                    throw SlackError.unknownError
                }
            case 429:
                throw SlackError.tooManyRequests
            default:
                throw SlackError.clientNetworkError
            }
        } catch let error {
            if let slackError = error as? SlackError {
                throw slackError
            } else {
                throw SlackError.unknownError
            }
        }
    }
    
    private func filterNilParameters(_ parameters: [String: Any?]) -> [String: Any] {
        var finalParameters = [String: Any]()
        for (key, value) in parameters {
            if let unwrapped = value {
                finalParameters[key] = unwrapped
            }
        }
        return finalParameters
    }
    
    private func randomBoundary() -> String {
        #if os(Linux)
            return "slackkit.boundary.\(Int(random()))\(Int(random()))"
        #else
            return "slackkit.boundary.\(arc4random())\(arc4random())"
        #endif
    }
}
