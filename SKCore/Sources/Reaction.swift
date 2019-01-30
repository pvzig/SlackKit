//
// Reaction.swift
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

public struct Reaction: Equatable {
    public let name: String?
    public var user: String?

    public init(reaction: [String: Any]?) {
        name = reaction?["name"] as? String
    }

    public init(name: String, user: String) {
        self.name = name
        self.user = user
    }

    static func reactionsFromArray(_ array: [[String: Any]]?) -> [Reaction] {
        var reactions = [Reaction]()
        if let array = array {
            for reaction in array {
                if let users = reaction["users"] as? [String], let name = reaction["name"] as? String {
                    for user in users {
                        reactions.append(Reaction(name: name, user: user))
                    }
                }
            }
        }
        return reactions
    }

    public static func == (lhs: Reaction, rhs: Reaction) -> Bool {
        return lhs.name == rhs.name
    }
}
