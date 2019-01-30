//
// SKResponse.swift
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

import Foundation
import SKCore

public struct SKResponse {
    let text: String
    let responseType: MessageResponseType
    let attachments: [Attachment]?

    public init(text: String, responseType: MessageResponseType = .inChannel, attachments: [Attachment]? = nil) {
        self.responseType = responseType
        self.text = text
        self.attachments = attachments
    }

    internal var json: [String: Any] {
        var json = [String: Any]()
        json["text"] = text
        json["response_type"] = responseType.rawValue
        json["attachments"] = attachments?.map({$0.dictionary})
        return json
    }

    internal var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self.json, options: [])
    }
}
