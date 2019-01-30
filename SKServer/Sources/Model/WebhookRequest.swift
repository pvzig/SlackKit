//
// WebhookRequest.swift
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

public struct WebhookRequest {
    public let token: String?
    public let teamID: String?
    public let teamDomain: String?
    public let channelID: String?
    public let channelName: String?
    public let ts: String?
    public let userID: String?
    public let userName: String?
    public let command: String?
    public let text: String?
    public let triggerWord: String?
    public let responseURL: String?

    internal init(request: [String: Any]?) {
        token = request?["token"] as? String
        teamID = request?["team_id"] as? String
        teamDomain = request?["team_domain"] as? String
        channelID = request?["channel_id"] as? String
        channelName = request?["channel_name"] as? String
        ts = request?["timestamp"] as? String
        userID = request?["user_id"] as? String
        userName = request?["user_name"] as? String
        command = request?["command"] as? String
        text = request?["text"] as? String
        triggerWord = request?["trigger_word"] as? String
        responseURL = request?["response_url"] as? String
    }
}
