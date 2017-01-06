//
// Channel.swift
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

public struct Channel {
    
    public let id: String?
    public let created: Int?
    public let creator: String?
    internal(set) public var name: String?
    internal(set) public var isArchived: Bool?
    internal(set) public var isGeneral: Bool?
    public let isGroup: Bool?
    public let isIM: Bool?
    public let isMPIM: Bool?
    internal(set) public var user: String?
    internal(set) public var isUserDeleted: Bool?
    internal(set) public var isOpen: Bool?
    internal(set) public var topic: Topic?
    internal(set) public var purpose: Topic?
    internal(set) public var isMember: Bool?
    public var lastRead: String?
    internal(set) public var latest: Message?
    public var unread: Int?
    public var unreadCountDisplay: Int?
    internal(set) public var hasPins: Bool?
    internal(set) public var members: [String]?
    // Client use
    internal(set) public var pinnedItems = [Item]()
    internal(set) public var usersTyping = [String]()
    internal(set) public var messages = [String: Message]()
    
    internal init(channel: [String: Any]?) {
        id = channel?["id"] as? String
        name = channel?["name"] as? String
        created = channel?["created"] as? Int
        creator = channel?["creator"] as? String
        isArchived = channel?["is_archived"] as? Bool
        isGeneral = channel?["is_general"] as? Bool
        isGroup = channel?["is_group"] as? Bool
        isIM = channel?["is_im"] as? Bool
        isMPIM = channel?["is_mpim"] as? Bool
        isUserDeleted = channel?["is_user_deleted"] as? Bool
        user = channel?["user"] as? String
        isOpen = channel?["is_open"] as? Bool
        topic = Topic(topic: channel?["topic"] as? [String: Any])
        purpose = Topic(topic: channel?["purpose"] as? [String: Any])
        isMember = channel?["is_member"] as? Bool
        lastRead = channel?["last_read"] as? String
        unread = channel?["unread_count"] as? Int
        unreadCountDisplay = channel?["unread_count_display"] as? Int
        hasPins = channel?["has_pins"] as? Bool
        members = channel?["members"] as? [String]
        
        if let latestMesssageDictionary = channel?["latest"] as? [String: Any] {
            latest = Message(dictionary: latestMesssageDictionary)
        } else {
            latest = Message(ts: channel?["latest"] as? String)
        }
    }
    
    internal init(id:String?) {
        self.id = id
        created = nil
        creator = nil
        isGroup = false
        isIM = false
        isMPIM = false
    }
}
