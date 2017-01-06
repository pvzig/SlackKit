//
// Comment.swift
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

public struct Comment: Equatable {
    
    public let id: String?
    public let user: String?
    internal(set) public var created: Int?
    internal(set) public var comment: String?
    internal(set) public var starred: Bool?
    internal(set) public var stars: Int?
    internal(set) public var reactions = [Reaction]()
    
    internal init(comment:[String: Any]?) {
        id = comment?["id"] as? String
        created = comment?["created"] as? Int
        user = comment?["user"] as? String
        starred = comment?["is_starred"] as? Bool
        stars = comment?["num_stars"] as? Int
        self.comment = comment?["comment"] as? String
    }
    
    internal init(id: String?) {
        self.id = id
        self.user = nil
    }
    
    public static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}
