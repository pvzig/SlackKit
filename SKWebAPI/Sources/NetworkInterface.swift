//
// NetworkInterface.swift
//
// Copyright © 2017 Peter Zignego. All rights reserved.
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

#if os(Linux)
    import Dispatch
#endif
import Foundation
import SKCore

public struct NetworkInterface {

    private let apiUrl = "https://slack.com/api/"
    private let session = URLSession(configuration: .default)

    internal init() {}

    internal func request(
        _ endpoint: Endpoint,
        parameters: [String: Any?],
        successClosure: @escaping ([String: Any]) -> Void,
        errorClosure: @escaping (SlackError) -> Void
    ) {
        guard let url = requestURL(for: endpoint, parameters: parameters) else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        let request = URLRequest(url: url)

        session.dataTask(with: request) {(data, response, publicError) in
            do {
                successClosure(try NetworkInterface.handleResponse(data, response: response, publicError: publicError))
            } catch let error {
                errorClosure(error as? SlackError ?? SlackError.unknownError)
            }
        }.resume()
    }

    //Adapted from https://gist.github.com/erica/baa8a187a5b4796dab27
    internal func synchronusRequest(_ endpoint: Endpoint, parameters: [String: Any?]) -> [String: Any]? {
        guard let url = requestURL(for: endpoint, parameters: parameters) else {
            return nil
        }
        let request = URLRequest(url: url)
        var data: Data? = nil
        var response: URLResponse? = nil
        var error: Error? = nil
        let semaphore = DispatchSemaphore(value: 0)
        session.dataTask(with: request) { (reqData, reqResponse, reqError) in
            data = reqData
            response = reqResponse
            error = reqError
            if data == nil, let error = error { print(error) }
            semaphore.signal()
        }.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return try? NetworkInterface.handleResponse(data, response: response, publicError: error)
    }

    internal func customRequest(
        _ url: String,
        data: Data,
        success: @escaping (Bool) -> Void,
        errorClosure: @escaping (SlackError) -> Void
    ) {
        guard let string = url.removingPercentEncoding, let url =  URL(string: string) else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let contentType = "application/json"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        session.dataTask(with: request) {(_, _, publicError) in
            if publicError == nil {
                success(true)
            } else {
                errorClosure(SlackError.clientNetworkError)
            }
        }.resume()
    }

    internal func uploadRequest(
        data: Data,
        parameters: [String: Any?],
        successClosure: @escaping ([String: Any]) -> Void, errorClosure: @escaping (SlackError) -> Void
    ) {
        guard
            let url = requestURL(for: .filesUpload, parameters: parameters),
            let filename = parameters["filename"] as? String,
            let filetype = parameters["filetype"] as? String
        else {
            errorClosure(SlackError.clientNetworkError)
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let boundaryConstant = randomBoundary()
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBodyData(data: data, boundaryConstant: boundaryConstant, filename: filename, filetype: filetype)

        session.dataTask(with: request) {(data, response, publicError) in
            do {
                successClosure(try NetworkInterface.handleResponse(data, response: response, publicError: publicError))
            } catch let error {
                errorClosure(error as? SlackError ?? SlackError.unknownError)
            }
        }.resume()
    }

    internal static func handleResponse(_ data: Data?, response: URLResponse?, publicError: Error?) throws -> [String: Any] {
        guard let data = data, let response = response as? HTTPURLResponse else {
            throw SlackError.clientNetworkError
        }
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw SlackError.clientJSONError
            }

            switch response.statusCode {
            case 200:
                if json["ok"] as? Bool == true {
                    return json
                } else {
                    if let errorString = json["error"] as? String {
                        throw SlackError(rawValue: errorString) ?? .unknownError
                    } else {
                        throw SlackError.unknownError
                    }
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

    private func requestURL(for endpoint: Endpoint, parameters: [String: Any?]) -> URL? {
        var components = URLComponents(string: "\(apiUrl)\(endpoint.rawValue)")
        if parameters.count > 0 {
            components?.queryItems = filterNilParameters(parameters).map { URLQueryItem(name: $0.0, value: "\($0.1)") }
        }

        // As discussed http://www.openradar.me/24076063 and https://stackoverflow.com/a/37314144/407523, Apple considers
        // a + and ? as valid characters in a URL query string, but Slack has recently started enforcing that they be
        // encoded when included in a query string. As a result, we need to manually apply the encoding after Apple's
        // default encoding is applied.
        var encodedQuery = components?.percentEncodedQuery
        encodedQuery = encodedQuery?.replacingOccurrences(of: ">", with: "%3E")
        encodedQuery = encodedQuery?.replacingOccurrences(of: "<", with: "%3C")
        encodedQuery = encodedQuery?.replacingOccurrences(of: "@", with: "%40")

        encodedQuery = encodedQuery?.replacingOccurrences(of: "?", with: "%3F")
        encodedQuery = encodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        components?.percentEncodedQuery = encodedQuery

        return components?.url
    }

    private func requestBodyData(data: Data, boundaryConstant: String, filename: String, filetype: String) -> Data? {
        let boundaryStart = "--\(boundaryConstant)\r\n"
        let boundaryEnd = "--\(boundaryConstant)--\r\n"
        let contentDispositionString = "Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n"
        let contentTypeString = "Content-Type: \(filetype)\r\n\r\n"
        let dataEnd = "\r\n"

        guard
            let boundaryStartData = boundaryStart.data(using: .utf8),
            let dispositionData = contentDispositionString.data(using: .utf8),
            let contentTypeData = contentTypeString.data(using: .utf8),
            let boundaryEndData = boundaryEnd.data(using: .utf8),
            let dataEndData = dataEnd.data(using: .utf8)
        else {
            return nil
        }

        var requestBodyData = Data()
        requestBodyData.append(contentsOf: boundaryStartData)
        requestBodyData.append(contentsOf: dispositionData)
        requestBodyData.append(contentsOf: contentTypeData)
        requestBodyData.append(contentsOf: data)
        requestBodyData.append(contentsOf: dataEndData)
        requestBodyData.append(contentsOf: boundaryEndData)
        return requestBodyData
    }

    private func randomBoundary() -> String {
        #if os(Linux)
            return "slackkit.boundary.\(Int(random()))\(Int(random()))"
        #else
            return "slackkit.boundary.\(arc4random())\(arc4random())"
        #endif
    }
}
