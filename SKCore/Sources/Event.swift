//
// Event.swift
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

public enum EventType: String {
    case hello = "hello"
    case message = "message"
    case userTyping = "user_typing"
    case channelMarked = "channel_marked"
    case channelCreated = "channel_created"
    case channelJoined = "channel_joined"
    case channelLeft = "channel_left"
    case channelDeleted = "channel_deleted"
    case channelRenamed = "channel_rename"
    case channelArchive = "channel_archive"
    case channelUnarchive = "channel_unarchive"
    case channelHistoryChanged = "channel_history_changed"
    case dndUpdated = "dnd_updated"
    case dndUpatedUser = "dnd_updated_user"
    case imCreated = "im_created"
    case imOpen = "im_open"
    case imClose = "im_close"
    case imMarked = "im_marked"
    case imHistoryChanged = "im_history_changed"
    case groupJoined = "group_joined"
    case groupLeft = "group_left"
    case groupOpen = "group_open"
    case groupClose = "group_close"
    case groupArchive = "group_archive"
    case groupUnarchive = "group_unarchive"
    case groupRename = "group_rename"
    case groupMarked = "group_marked"
    case groupHistoryChanged = "group_history_changed"
    case fileCreated = "file_created"
    case fileShared = "file_shared"
    case fileUnshared = "file_unshared"
    case filePublic = "file_public"
    case filePrivate = "file_private"
    case fileChanged = "file_change"
    case fileDeleted = "file_deleted"
    case fileCommentAdded = "file_comment_added"
    case fileCommentEdited = "file_comment_edited"
    case fileCommentDeleted = "file_comment_deleted"
    case pinAdded = "pin_added"
    case pinRemoved = "pin_removed"
    case pong = "pong"
    case presenceChange = "presence_change"
    case manualPresenceChange = "manual_presence_change"
    case prefChange = "pref_change"
    case userChange = "user_change"
    case teamJoin = "team_join"
    case starAdded = "star_added"
    case starRemoved = "star_removed"
    case reactionAdded = "reaction_added"
    case reactionRemoved = "reaction_removed"
    case emojiChanged = "emoji_changed"
    case commandsChanged = "commands_changed"
    case teamPlanChange = "team_plan_change"
    case teamPrefChange = "team_pref_change"
    case teamRename = "team_rename"
    case teamDomainChange = "team_domain_change"
    case emailDomainChange = "email_domain_change"
    case teamProfileChange = "team_profile_change"
    case teamProfileDelete = "team_profile_delete"
    case teamProfileReorder = "team_profile_reorder"
    case botAdded = "bot_added"
    case botChanged = "bot_changed"
    case accountsChanged = "accounts_changed"
    case teamMigrationStarted = "team_migration_started"
    case reconnectURL = "reconnect_url"
    case subteamCreated = "subteam_created"
    case subteamUpdated = "subteam_updated"
    case subteamSelfAdded = "subteam_self_added"
    case subteamSelfRemoved = "subteam_self_removed"
    case ok = "ok"
    case error = "error"
    case goodbye = "goodbye"
    case unknown = "unknown"
}

public enum MessageSubtype: String {
    case botMessage = "bot_message"
    case meMessage = "me_message"
    case messageChanged = "message_changed"
    case messageDeleted = "message_deleted"
    case channelJoin = "channel_join"
    case channelLeave = "channel_leave"
    case channelTopic = "channel_topic"
    case channelPurpose = "channel_purpose"
    case channelName = "channel_name"
    case channelArchive = "channel_archive"
    case channelUnarchive = "channel_unarchive"
    case groupJoin = "group_join"
    case groupLeave = "group_leave"
    case groupTopic = "group_topic"
    case groupPurpose = "group_purpose"
    case groupName = "group_name"
    case groupArchive = "group_archive"
    case groupUnarchive = "group_unarchive"
    case fileShare = "file_share"
    case fileComment = "file_comment"
    case fileMention = "file_mention"
    case messageReplied = "message_replied"
    case pinnedItem = "pinned_item"
    case replyBroadcast = "reply_broadcast"
    case unpinnedItem = "unpinned_item"
}

public class Event {
    public let type: EventType?
    public let ts: String?
    public let subtype: String?
    public let channelID: String?
    public let text: String?
    public let eventTs: String?
    public let latest: String?
    public let hidden: Bool?
    public let isStarred: Bool?
    public let hasPins: Bool?
    public let pinnedTo: [String]?
    public let fileID: String?
    public let presence: String?
    public let name: String?
    public let value: Any?
    public let plan: String?
    public let url: String?
    public let domain: String?
    public let emailDomain: String?
    public let reaction: String?
    public let replyTo: Double?
    public let reactions: [[String: Any]]?
    public let edited: Edited?
    public let bot: Bot?
    public let channel: Channel?
    public let comment: Comment?
    public let user: User?
    public let file: File?
    public let message: Message?
    public let nestedMessage: Message?
    public let itemUser: String?
    public let item: Item?
    public let dndStatus: DoNotDisturbStatus?
    public let subteam: UserGroup?
    public let subteamID: String?
    public var profile: CustomProfile?

    //swiftlint:disable function_body_length
    public init(_ event: [String: Any]) {
        type = EventType(rawValue: event["type"] as? String ?? "ok")
        ts = event["ts"] as? String
        subtype = event["subtype"] as? String
        channelID = event["channel_id"] as? String
        text = event["text"] as? String
        eventTs = event["event_ts"] as? String
        latest = event["latest"] as? String
        hidden = event["hidden"] as? Bool
        isStarred = event["is_starred"] as? Bool
        hasPins = event["has_pins"] as? Bool
        pinnedTo = event["pinned_top"] as? [String]
        fileID = event["file_id"] as? String
        presence = event["presence"] as? String
        name = event["name"] as? String
        value = event["value"]
        plan = event["plan"] as? String
        url = event["url"] as? String
        domain = event["domain"] as? String
        emailDomain = event["email_domain"] as? String
        reaction = event["reaction"] as? String
        replyTo = event["reply_to"] as? Double
        reactions = event["reactions"] as? [[String: Any]]
        bot = Bot(bot: event["bot"] as? [String: Any])
        edited = Edited(edited:event["edited"] as? [String: Any])
        dndStatus = DoNotDisturbStatus(status: event["dnd_status"] as? [String: Any])
        itemUser = event["item_user"] as? String
        item = Item(item: event["item"] as? [String: Any])
        subteam = UserGroup(userGroup: event["subteam"] as? [String: Any])
        subteamID = event["subteam_id"] as? String
        message = Message(dictionary: event)
        nestedMessage = Message(dictionary: event["message"] as? [String: Any])
        profile = CustomProfile(profile: event["profile"] as? [String: Any])
        file = File(id: event["file"] as? String)

        // Comment, Channel, and User can come across as Strings or Dictionaries
        if let commentDictionary = event["comment"] as? [String: Any] {
            comment = Comment(comment: commentDictionary)
        } else {
            comment = Comment(id: event["comment"] as? String)
        }

        if let userDictionary = event["user"] as? [String: Any] {
            user = User(user: userDictionary)
        } else {
            user = User(id: event["user"] as? String)
        }

        if let channelDictionary =  event["channel"] as? [String: Any] {
            channel = Channel(channel: channelDictionary)
        } else {
            channel = Channel(id: event["channel"] as? String)
        }
    }
}
