//
// Message.swift
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

public final class Message: Equatable {
    
    public let type = "message"
    public let subtype: String?
    internal(set) public var ts: String?
    public let user: String?
    public let channel: String?
    internal(set) public var hidden: Bool?
    internal(set) public var text: String?
    public let botID: String?
    public let username: String?
    public let icons: [String: Any]?
    public let deletedTs: String?
    internal(set) var purpose: String?
    internal(set) var topic: String?
    internal(set) var name: String?
    internal(set) var members: [String]?
    internal(set) var oldName: String?
    public let upload: Bool?
    public let itemType: String?
    internal(set) public var isStarred: Bool?
    internal(set) var pinnedTo: [String]?
    public let comment: Comment?
    public let file: File?
    internal(set) public var reactions = [Reaction]()
    internal(set) public var attachments: [Attachment]?
    internal(set) public var responseType: ResponseType?
    internal(set) public var replaceOriginal: Bool?
    internal(set) public var deleteOriginal: Bool?
    
    public init(dictionary: [String: Any]?) {
        subtype = dictionary?["subtype"] as? String
        ts = dictionary?["ts"] as? String
        user = dictionary?["user"] as? String
        channel = dictionary?["channel"] as? String
        hidden = dictionary?["hidden"] as? Bool
        text = dictionary?["text"] as? String
        botID = dictionary?["bot_id"] as? String
        username = dictionary?["username"] as? String
        icons = dictionary?["icons"] as? [String: Any]
        deletedTs = dictionary?["deleted_ts"] as? String
        purpose = dictionary?["purpose"] as? String
        topic = dictionary?["topic"] as? String
        name = dictionary?["name"] as? String
        members = dictionary?["members"] as? [String]
        oldName = dictionary?["old_name"] as? String
        upload = dictionary?["upload"] as? Bool
        itemType = dictionary?["item_type"] as? String
        isStarred = dictionary?["is_starred"] as? Bool
        pinnedTo = dictionary?["pinned_to"] as? [String]
        comment = Comment(comment: dictionary?["comment"] as? [String: Any])
        file = File(file: dictionary?["file"] as? [String: Any])
        reactions = Reaction.reactionsFromArray(dictionary?["reactions"] as? [[String: Any]])
        attachments = (dictionary?["attachments"] as? [[String: Any]])?.map{Attachment(attachment: $0)}
        responseType = ResponseType(rawValue: dictionary?["response_type"] as? String ?? "")
        replaceOriginal = dictionary?["replace_original"] as? Bool
        deleteOriginal = dictionary?["delete_original"] as? Bool
    }
    
    internal init(ts:String?) {
        self.ts = ts
        subtype = nil
        user = nil
        channel = nil
        botID = nil
        username = nil
        icons = nil
        deletedTs = nil
        upload = nil
        itemType = nil
        comment = nil
        file = nil
    }
    
    public static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.ts == rhs.ts && lhs.user == rhs.user && lhs.text == rhs.text
    }
}
