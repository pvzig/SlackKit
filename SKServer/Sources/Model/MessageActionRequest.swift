//
// MessageActionRequest.swift
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

import SKCore

public struct MessageActionRequest {
    public let action: Action?
    public let callbackID: String?
    public let team: Team?
    public let channel: Channel?
    public let user: User?
    public let actionTS: String?
    public let messageTS: String?
    public let attachmentID: String?
    public let token: String?
    public let originalMessage: Message?
    public let responseURL: String?

    internal init(response: [String: Any]?) {
        action = (response?["actions"] as? [Any])?.map({$0 as? [String: Any]}).first.map({Action(action: $0)})
        callbackID = response?["callback_id"] as? String
        team = Team(team: response?["team"] as? [String: Any])
        channel = Channel(channel: response?["channel"] as? [String: Any])
        user = User(user: response?["channel"] as? [String: Any])
        actionTS = response?["action_ts"] as? String
        messageTS = response?["message_ts"] as? String
        attachmentID = response?["attachment_id"] as? String
        token = response?["token"] as? String
        originalMessage = Message(dictionary: response?["original_message"] as? [String: Any])
        responseURL = response?["response_url"] as? String
    }
}
