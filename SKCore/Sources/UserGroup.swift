//
// UserGroup.swift
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

public struct UserGroup {
    public let id: String?
    public var teamID: String?
    public let isUserGroup: Bool?
    public var name: String?
    public var description: String?
    public var handle: String?
    public var isExternal: Bool?
    public let dateCreated: Int?
    public var dateUpdated: Int?
    public var dateDeleted: Int?
    public var autoType: String?
    public let createdBy: String?
    public var updatedBy: String?
    public var deletedBy: String?
    public var preferences: [String: Any]?
    public var users: [String]?
    public var userCount: Int?

    public init(userGroup: [String: Any]?) {
        id = userGroup?["id"] as? String
        teamID = userGroup?["team_id"] as? String
        isUserGroup = userGroup?["is_usergroup"] as? Bool
        name = userGroup?["name"] as? String
        description = userGroup?["description"] as? String
        handle = userGroup?["handle"] as? String
        isExternal = userGroup?["is_external"] as? Bool
        dateCreated = userGroup?["date_create"] as? Int
        dateUpdated = userGroup?["date_update"] as? Int
        dateDeleted = userGroup?["date_delete"] as? Int
        autoType = userGroup?["auto_type"] as? String
        createdBy = userGroup?["created_by"] as? String
        updatedBy = userGroup?["updated_by"] as? String
        deletedBy = userGroup?["deleted_by"] as? String
        preferences = userGroup?["prefs"] as? [String: Any]
        users = userGroup?["users"] as? [String]
        if let count = userGroup?["user_count"] as? String {
            userCount = Int(count)
        }
    }
}
