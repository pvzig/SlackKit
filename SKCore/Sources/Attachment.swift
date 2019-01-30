//
// Attachment.swift
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

public struct Attachment {
    public let fallback: String?
    public let callbackID: String?
    public let type: String?
    public let color: String?
    public let pretext: String?
    public let authorName: String?
    public let authorLink: String?
    public let authorIcon: String?
    public let title: String?
    public let titleLink: String?
    public let text: String?
    public let fields: [AttachmentField]?
    public let actions: [Action]?
    public let imageURL: String?
    public let thumbURL: String?
    public let footer: String?
    public let footerIcon: String?
    public let ts: Int?
    public let markdownEnabledFields: Set<AttachmentTextField>?

    public init(attachment: [String: Any]?) {
        fallback = attachment?["fallback"] as? String
        callbackID = attachment?["callback_id"] as? String
        type = attachment?["attachment_type"] as? String
        color = attachment?["color"] as? String
        pretext = attachment?["pretext"] as? String
        authorName = attachment?["author_name"] as? String
        authorLink = attachment?["author_link"] as? String
        authorIcon = attachment?["author_icon"] as? String
        title = attachment?["title"] as? String
        titleLink = attachment?["title_link"] as? String
        text = attachment?["text"] as? String
        imageURL = attachment?["image_url"] as? String
        thumbURL = attachment?["thumb_url"] as? String
        footer = attachment?["footer"] as? String
        footerIcon = attachment?["footer_icon"] as? String
        ts = attachment?["ts"] as? Int
        fields = (attachment?["fields"] as? [[String: Any]])?.map { AttachmentField(field: $0) }
        actions = (attachment?["actions"] as? [[String: Any]])?.map { Action(action: $0) }
        markdownEnabledFields = (attachment?["mrkdwn_in"] as? [String]).map { Set($0.compactMap(AttachmentTextField.init)) }
    }

    public init(
        fallback: String,
        title: String?,
        callbackID: String? = nil,
        type: String? = nil,
        colorHex: String? = nil,
        pretext: String? = nil,
        authorName: String? = nil,
        authorLink: String? = nil,
        authorIcon: String? = nil,
        titleLink: String? = nil,
        text: String? = nil,
        fields: [AttachmentField]? = nil,
        actions: [Action]? = nil,
        imageURL: String? = nil,
        thumbURL: String? = nil,
        footer: String? = nil,
        footerIcon: String? = nil,
        ts: Int? = nil,
        markdownFields: Set<AttachmentTextField>? = nil
    ) {
        self.fallback = fallback
        self.callbackID = callbackID
        self.type = type
        self.color = colorHex
        self.pretext = pretext
        self.authorName = authorName
        self.authorLink = authorLink
        self.authorIcon = authorIcon
        self.title = title
        self.titleLink = titleLink
        self.text = text
        self.fields = fields
        self.actions = actions
        self.imageURL = imageURL
        self.thumbURL = thumbURL
        self.footer = footer
        self.footerIcon = footerIcon
        self.ts = ts
        self.markdownEnabledFields = markdownFields
    }

    public var dictionary: [String: Any] {
        var attachment = [String: Any]()
        attachment["fallback"] = fallback
        attachment["callback_id"] = callbackID
        attachment["attachment_type"] = type
        attachment["color"] = color
        attachment["pretext"] = pretext
        attachment["author_name"] = authorName
        attachment["author_link"] = authorLink
        attachment["author_icon"] = authorIcon
        attachment["title"] = title
        attachment["title_link"] = titleLink
        attachment["text"] = text
        attachment["fields"] = fields?.map { $0.dictionary }
        attachment["actions"] = actions?.map { $0.dictionary }
        attachment["image_url"] = imageURL
        attachment["thumb_url"] = thumbURL
        attachment["footer"] = footer
        attachment["footer_icon"] = footerIcon
        attachment["ts"] = ts
        attachment["mrkdwn_in"] = markdownEnabledFields?.map { $0.rawValue }
        return attachment
    }
}

public enum AttachmentColor: String {
    case good, warning, danger
}

public enum AttachmentTextField: String {
    case fallback = "fallback"
    case pretext = "pretext"
    case authorName = "author_name"
    case title = "title"
    case text = "text"
    case fields = "fields"
    case footer = "footer"
}
