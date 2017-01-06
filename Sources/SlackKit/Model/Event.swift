//
// Event.swift
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

internal enum EventType: String {
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
    case unknown = "unknown"
}

internal enum MessageSubtype: String {
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
    case pinnedItem = "pinned_item"
    case unpinnedItem = "unpinned_item"
}

internal class Event {
    let type: EventType?
    let ts: String?
    let subtype: String?
    let channelID: String?
    let text: String?
    let eventTs: String?
    let latest: String?
    let hidden: Bool?
    let isStarred: Bool?
    let hasPins: Bool?
    let pinnedTo: [String]?
    let fileID: String?
    let presence: String?
    let name: String?
    let value: Any?
    let plan: String?
    let url: String?
    let domain: String?
    let emailDomain: String?
    let reaction: String?
    let replyTo: Double?
    let reactions: [[String: Any]]?
    let edited: Edited?
    let bot: Bot?
    let channel: Channel?
    let comment: Comment?
    let user: User?
    let file: File?
    let message: Message?
    let nestedMessage: Message?
    let itemUser: String?
    let item: Item?
    let dndStatus: DoNotDisturbStatus?
    let subteam: UserGroup?
    let subteamID: String?
    var profile: CustomProfile?
    
    init(_ event:[String: Any]) {
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
