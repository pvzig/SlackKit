//
// IncomingWebhook.swift
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

public struct IncomingWebhook {
    
    public let url: String?
    public let channel: String?
    public let configurationURL: String?
    public let username: String?
    public let iconEmoji: String?
    public let iconURL: String?
    
    internal init(webhook: [String: Any]?) {
        url = webhook?["url"] as? String
        channel = webhook?["channel"] as? String
        configurationURL = webhook?["configuration_url"] as? String
        username = webhook?["username"] as? String
        iconEmoji = webhook?["icon_emoji"] as? String
        iconURL = webhook?["icon_url"] as? String
    }
    
    public init(url: String, channel: String? = nil, username: String? = nil, iconEmoji: String? = nil, iconURL: String? = nil) {
        self.url = url
        self.channel = channel
        self.username = username
        self.iconEmoji = iconEmoji
        self.iconURL = iconURL
        self.configurationURL = nil
    }
    
    public func postMessage(_ response: Response, success: ((Bool)->Void)? = nil, failure: ((SlackError)->Void)? = nil) {
        if let url = self.url, let data = try? JSONSerialization.data(withJSONObject: jsonBody(response.json()), options: []) {
            NetworkInterface().customRequest(url, data: data, success: { _ in
                success?(true)
            }, errorClosure: {(error) in
                failure?(error)
            })
        }
    }
    
    private func jsonBody(_ response: [String: Any]) -> [String: Any] {
        var json = response
        json["channel"] = channel
        json["username"] = username
        json["icon_emoji"] = iconEmoji
        json["icon_url"] = iconURL
        return json
    }
    
}
