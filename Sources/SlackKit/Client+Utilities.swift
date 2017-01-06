//
// Client+Utilities.swift
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

public enum ClientError: Error {
    case channelDoesNotExist
    case userDoesNotExist
}

public extension SlackClient {
    
    //MARK: - User & Channel
    public func getChannelIDWith(name: String) throws -> String {
        guard let id = channels.filter({$0.1.name == strip(string:name)}).first?.0 else {
            throw ClientError.channelDoesNotExist
        }
        return id
    }
    
    public func getUserIDWith(name: String) throws -> String {
        guard let id = users.filter({$0.1.name == strip(string:name)}).first?.0 else {
            throw ClientError.userDoesNotExist
        }
        return id
    }
    
    public func getImIDForUserWith(id: String, success: @escaping (_ imID: String?)->Void, failure: @escaping (SlackError)->Void) {
        let ims = channels.filter{$0.1.isIM == true}
        let channel = ims.filter{$0.1.user == id}.first
        if let channel = channel {
            success(channel.0)
        } else {
            webAPI.openIM(userID: id, success: success, failure: failure)
        }
    }
    
    //MARK: - Utilities
    internal func strip(string: String) -> String {
        var strippedString = string
        if string[string.startIndex] == "@" || string[string.startIndex] == "#" {
            strippedString = string.substring(from: string.characters.index(string.startIndex, offsetBy: 1))
        }
        return strippedString
    }
}
