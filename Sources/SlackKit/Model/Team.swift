//
// Team.swift
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

public struct Team {
    
    public let id: String?
    internal(set) public var name: String?
    internal(set) public var domain: String?
    internal(set) public var emailDomain: String?
    internal(set) public var messageEditWindowMinutes: Int?
    internal(set) public var overStorageLimit: Bool?
    internal(set) public var prefs: [String: Any]?
    internal(set) public var plan: String?
    internal(set) public var icon: TeamIcon?
    
    internal init(team: [String: Any]?) {
        id = team?["id"] as? String
        name = team?["name"] as? String
        domain = team?["domain"] as? String
        emailDomain = team?["email_domain"] as? String
        messageEditWindowMinutes = team?["msg_edit_window_mins"] as? Int
        overStorageLimit = team?["over_storage_limit"] as? Bool
        prefs = team?["prefs"] as? [String: Any]
        plan = team?["plan"] as? String
        icon = TeamIcon(icon: team?["icon"] as? [String: Any])
    }
}
