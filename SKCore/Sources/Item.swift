//
// Item.swift
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

public struct Item: Equatable {
    public let type: String?
    public let ts: String?
    public let channel: String?
    public let message: Message?
    public let file: File?
    public let comment: Comment?
    public let fileCommentID: String?

    public init(item: [String: Any]?) {
        type = item?["type"] as? String
        ts = item?["ts"] as? String
        channel = item?["channel"] as? String
        message = Message(dictionary: item?["message"] as? [String: Any])

        // Comment and File can come across as Strings or Dictionaries
        if let commentDictionary = item?["comment"] as? [String: Any] {
            comment = Comment(comment: commentDictionary)
        } else {
            comment = Comment(id: item?["comment"] as? String)
        }

        if let fileDictionary = item?["file"] as? [String: Any] {
            file = File(file: fileDictionary)
        } else {
            file = File(id: item?["file"] as? String)
        }

        fileCommentID = item?["file_comment"] as? String
    }

    public static func == (lhs: Item, rhs: Item) -> Bool {
        return
            lhs.type == rhs.type &&
            lhs.channel == rhs.channel &&
            lhs.file == rhs.file &&
            lhs.comment == rhs.comment &&
            lhs.message == rhs.message
    }
}
