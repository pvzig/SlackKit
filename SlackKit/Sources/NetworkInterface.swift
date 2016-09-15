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

internal struct NetworkInterface {
    
    private let apiUrl = "https://slack.com/api/"
    
    internal func request(_ endpoint: Endpoint, token: String? = nil, parameters: [String: Any]?, successClosure: @escaping ([String: Any])->Void, errorClosure: @escaping (SlackError)->Void) {
        var requestString = "\(apiUrl)\(endpoint.rawValue)?"
        if let token = token {
            requestString += "token=\(token)"
        }
        if let params = parameters {
            requestString += params.requestStringFromParameters
        }
        guard let url =  URL(string: requestString) else {
            errorClosure(SlackError.ClientNetworkError)
            return
        }
        let request = URLRequest(url:url)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, internalError) -> Void in
            self.handleResponse(data, response: response, internalError: internalError, successClosure: {(json) in
                successClosure(json)
            }, errorClosure: {(error) in
                errorClosure(error)
            })
        }.resume()
    }
    
    internal func customRequest(_ url: String, data: Data, success: @escaping (Bool)->Void, errorClosure: @escaping (SlackError)->Void) {
        guard let url =  URL(string: url.removePercentEncoding()) else {
            errorClosure(SlackError.ClientNetworkError)
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let contentType = "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) {
            (data, response, internalError) -> Void in
            if internalError == nil {
                success(true)
            } else {
                errorClosure(SlackError.ClientNetworkError)
            }
            }.resume()
    }
    
    internal func uploadRequest(_ token: String, data: Data, parameters: [String: Any]?, successClosure: @escaping ([String: Any])->Void, errorClosure: @escaping (SlackError)->Void) {
        var requestString = "\(apiUrl)\(Endpoint.FilesUpload.rawValue)?token=\(token)"
        if let params = parameters {
            requestString = requestString + params.requestStringFromParameters
        }
        guard let url =  URL(string: requestString) else {
            errorClosure(SlackError.ClientNetworkError)
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let boundaryConstant = randomBoundary()
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(parameters!["filename"])\"\r\n"
        let contentTypeString = "Content-Type: \(parameters!["filetype"])\r\n\r\n"

        var requestBodyData: Data = Data()
        requestBodyData.append(boundaryStart.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentDispositionString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(contentTypeString.data(using: String.Encoding.utf8)!)
        requestBodyData.append(data)
        requestBodyData.append("\r\n".data(using: String.Encoding.utf8)!)
        requestBodyData.append(boundaryEnd.data(using: String.Encoding.utf8)!)
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyData as Data

        URLSession.shared.dataTask(with: request) {
            (data, response, internalError) -> Void in
            self.handleResponse(data, response: response, internalError: internalError, successClosure: {(json) in
                successClosure(json)
            }, errorClosure: {(error) in
                errorClosure(error)
            })
        }.resume()
    }
    
    private func handleResponse(_ data: Data?, response:URLResponse?, internalError:Error?, successClosure: ([String: Any])->Void, errorClosure: (SlackError)->Void) {
        guard let data = data, let response = response as? HTTPURLResponse else {
            errorClosure(SlackError.ClientNetworkError)
            return
        }
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                errorClosure(SlackError.ClientJSONError)
                return
            }
            
            switch response.statusCode {
            case 200:
                if (json["ok"] as! Bool == true) {
                    successClosure(json)
                } else {
                    if let errorString = json["error"] as? String {
                        throw SlackError(rawValue: errorString) ?? .UnknownError
                    } else {
                        throw SlackError.UnknownError
                    }
                }
            case 429:
                throw SlackError.TooManyRequests
            default:
                throw SlackError.ClientNetworkError
            }
        } catch let error {
            if let slackError = error as? SlackError {
                errorClosure(slackError)
            } else {
                errorClosure(SlackError.UnknownError)
            }
        }
    }
    
    private func randomBoundary() -> String {
        return String(format: "slackkit.boundary.%08x%08x", arc4random(), arc4random())
    }
    
}
