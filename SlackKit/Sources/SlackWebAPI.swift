//
// SlackWebAPI.swift
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

import Foundation

internal enum SlackAPIEndpoint: String {
    case APITest = "api.test"
    case AuthTest = "auth.test"
    case ChannelsHistory = "channels.history"
    case ChannelsInfo = "channels.info"
    case ChannelsList = "channels.list"
    case ChannelsMark = "channels.mark"
    case ChannelsSetPurpose = "channels.setPurpose"
    case ChannelsSetTopic = "channels.setTopic"
    case ChatDelete = "chat.delete"
    case ChatPostMessage = "chat.postMessage"
    case ChatUpdate = "chat.update"
    case EmojiList = "emoji.list"
    case FilesDelete = "files.delete"
    case FilesUpload = "files.upload"
    case GroupsClose = "groups.close"
    case GroupsHistory = "groups.history"
    case GroupsInfo = "groups.info"
    case GroupsList = "groups.list"
    case GroupsMark = "groups.mark"
    case GroupsOpen = "groups.open"
    case GroupsSetPurpose = "groups.setPurpose"
    case GroupsSetTopic = "groups.setTopic"
    case IMClose = "im.close"
    case IMHistory = "im.history"
    case IMList = "im.list"
    case IMMark = "im.mark"
    case IMOpen = "im.open"
    case MPIMClose = "mpim.close"
    case MPIMHistory = "mpim.history"
    case MPIMList = "mpim.list"
    case MPIMMark = "mpim.mark"
    case MPIMOpen = "mpim.open"
    case PinsAdd = "pins.add"
    case PinsRemove = "pins.remove"
    case ReactionsAdd = "reactions.add"
    case ReactionsGet = "reactions.get"
    case ReactionsList = "reactions.list"
    case ReactionsRemove = "reactions.remove"
    case RTMStart = "rtm.start"
    case StarsAdd = "stars.add"
    case StarsRemove = "stars.remove"
    case TeamInfo = "team.info"
    case UsersGetPresence = "users.getPresence"
    case UsersInfo = "users.info"
    case UsersList = "users.list"
    case UsersSetActive = "users.setActive"
    case UsersSetPresence = "users.setPresence"
}

public class SlackWebAPI {
    
    public typealias FailureClosure = (error: SlackError)->Void
    
    public enum InfoType: String {
        case Purpose = "purpose"
        case Topic = "topic"
    }
    
    public enum ParseMode: String {
        case Full = "full"
        case None = "none"
    }
    
    public enum Presence: String {
        case Auto = "auto"
        case Away = "away"
    }
    
    private enum ChannelType: String {
        case Channel = "channel"
        case Group = "group"
        case IM = "im"
    }
    
    private let client: Client
    
    required public init(client: Client) {
        self.client = client
    }
    
    //MARK: - RTM
    public func rtmStart(success success: ((response: [String: AnyObject])->Void)?, failure: FailureClosure?) {
        client.api.request(.RTMStart, token: client.token, parameters: nil, successClosure: {
                (response) -> Void in
                success?(response: response)
            }) {(error) -> Void in
                failure?(error: error)
            }
    }
    
    //MARK: - Auth Test
    public func authenticationTest(success: ((authenticated: Bool)->Void)?, failure: FailureClosure?) {
        client.api.request(.AuthTest, token: client.token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(authenticated: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Channels
    public func channelHistory(id: String, latest: String = "\(NSDate().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((history: History?)->Void)?, failure: FailureClosure?) {
        history(.ChannelsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history: history)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func channelInfo(id: String, success: ((channel: Channel?)->Void)?, failure: FailureClosure?) {
        info(.ChannelsInfo, type:ChannelType.Channel, id: id, success: {
            (channel) -> Void in
                success?(channel: channel)
            }) { (error) -> Void in
                failure?(error: error)
        }
    }
    
    public func channelsList(excludeArchived: Bool = false, success: ((channels: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        list(.ChannelsList, type:ChannelType.Channel, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels: channels)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func markChannel(channel: String, timestamp: String, success: ((ts: String)->Void)?, failure: FailureClosure?) {
        mark(.ChannelsMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(ts:timestamp)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setChannelPurpose(channel: String, purpose: String, success: ((purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.ChannelsSetPurpose, type: .Purpose, channel: channel, text: purpose, success: {
            (purposeSet) -> Void in
                success?(purposeSet: purposeSet)
            }) { (error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setChannelTopic(channel: String, topic: String, success: ((topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.ChannelsSetTopic, type: .Topic, channel: channel, text: topic, success: {
            (topicSet) -> Void in
                success?(topicSet: topicSet)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Messaging
    public func deleteMessage(channel: String, ts: String, success: ((deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel": channel, "ts": ts]
        client.api.request(.ChatDelete, token: client.token, parameters: parameters, successClosure: { (response) -> Void in
                success?(deleted: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func sendMessage(channel: String, text: String, username: String? = nil, asUser: Bool = false, parse: ParseMode = .Full, linkNames: Bool = false, attachments: [Attachment?]? = nil, unfurlLinks: Bool = false, unfurlMedia: Bool = false, iconURL: String? = nil, iconEmoji: String? = nil, success: (((ts: String?, channel: String?))->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["channel":channel, "text":text.slackFormatEscaping(), "as_user":asUser, "parse":parse.rawValue, "link_names":linkNames, "unfurl_links":unfurlLinks, "unfurlMedia":unfurlMedia, "username":username, "attachments":encodeAttachments(attachments), "icon_url":iconURL, "icon_emoji":iconEmoji]
        client.api.request(.ChatPostMessage, token: client.token, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?((ts: response["ts"] as? String, response["channel"] as? String))
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func updateMessage(channel: String, ts: String, message: String, attachments: [Attachment?]? = nil, parse:ParseMode = .None, linkNames: Bool = false, success: ((updated: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["channel": channel, "ts": ts, "text": message.slackFormatEscaping(), "parse": parse.rawValue, "link_names": linkNames, "attachments":encodeAttachments(attachments)]
        client.api.request(.ChatUpdate, token: client.token, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(updated: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Emoji
    public func emojiList(success: ((emojiList: [String: AnyObject]?)->Void)?, failure: FailureClosure?) {
        client.api.request(.EmojiList, token: client.token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(emojiList: response["emoji"] as? [String: AnyObject])
            }) { (error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Files
    public func deleteFile(fileID: String, success: ((deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["file":fileID]
        client.api.request(.FilesDelete, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(deleted: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func uploadFile(file: NSData, filename: String, filetype: String = "auto", title: String? = nil, initialComment: String? = nil, channels: [String]? = nil, success: ((file: File?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["file":file, "filename": filename, "filetype":filetype, "title":title, "initial_comment":initialComment, "channels":channels?.joinWithSeparator(",")]
        client.api.uploadRequest(client.token, data: file, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(file: File(file: response["file"] as? [String: AnyObject]))
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Groups
    public func closeGroup(groupID: String, success: ((closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.GroupsClose, channelID: groupID, success: {
            (closed) -> Void in
                success?(closed:closed)
            }) {(error) -> Void in
                failure?(error:error)
        }
    }
    
    public func groupHistory(id: String, latest: String = "\(NSDate().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((history: History?)->Void)?, failure: FailureClosure?) {
        history(.GroupsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history: history)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func groupInfo(id: String, success: ((channel: Channel?)->Void)?, failure: FailureClosure?) {
        info(.GroupsInfo, type:ChannelType.Group, id: id, success: {
            (channel) -> Void in
                success?(channel: channel)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func groupsList(excludeArchived: Bool = false, success: ((channels: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        list(.GroupsList, type:ChannelType.Group, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels: channels)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func markGroup(channel: String, timestamp: String, success: ((ts: String)->Void)?, failure: FailureClosure?) {
        mark(.GroupsMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(ts: timestamp)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func openGroup(channel: String, success: ((opened: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["channel":channel]
        client.api.request(.GroupsOpen, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(opened: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setGroupPurpose(channel: String, purpose: String, success: ((purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.GroupsSetPurpose, type: .Purpose, channel: channel, text: purpose, success: {
            (purposeSet) -> Void in
                success?(purposeSet: purposeSet)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setGroupTopic(channel: String, topic: String, success: ((topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.GroupsSetTopic, type: .Topic, channel: channel, text: topic, success: {
            (topicSet) -> Void in
                success?(topicSet: topicSet)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - IM
    public func closeIM(channel: String, success: ((closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.IMClose, channelID: channel, success: {
            (closed) -> Void in
                success?(closed: closed)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func imHistory(id: String, latest: String = "\(NSDate().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((history: History?)->Void)?, failure: FailureClosure?) {
        history(.IMHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history: history)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func imsList(excludeArchived: Bool = false, success: ((channels: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        list(.IMList, type:ChannelType.IM, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels: channels)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func markIM(channel: String, timestamp: String, success: ((ts: String)->Void)?, failure: FailureClosure?) {
        mark(.IMMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(ts: timestamp)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func openIM(userID: String, success: ((imID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["user":userID]
        client.api.request(.IMOpen, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                let group = response["channel"] as? [String: AnyObject]
                success?(imID: group?["id"] as? String)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - MPIM
    public func closeMPIM(channel: String, success: ((closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.MPIMClose, channelID: channel, success: {
            (closed) -> Void in
                success?(closed: closed)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func mpimHistory(id: String, latest: String = "\(NSDate().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((history: History?)->Void)?, failure: FailureClosure?) {
        history(.MPIMHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {
            (history) -> Void in
                success?(history: history)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func mpimsList(excludeArchived: Bool = false, success: ((channels: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        list(.MPIMList, type:ChannelType.Group, excludeArchived: excludeArchived, success: {
            (channels) -> Void in
                success?(channels: channels)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func markMPIM(channel: String, timestamp: String, success: ((ts: String)->Void)?, failure: FailureClosure?) {
        mark(.MPIMMark, channel: channel, timestamp: timestamp, success: {
            (ts) -> Void in
                success?(ts: timestamp)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func openMPIM(userIDs: [String], success: ((mpimID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["users":userIDs.joinWithSeparator(",")]
        client.api.request(.MPIMOpen, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                let group = response["group"] as? [String: AnyObject]
                success?(mpimID: group?["id"] as? String)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Pins
    public func pinItem(channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((pinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.PinsAdd, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(pinned: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func unpinItem(channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((unpinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.PinsRemove, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(unpinned: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func pin(endpoint: SlackAPIEndpoint, channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["channel":channel, "file":file, "file_comment":fileComment, "timestamp":timestamp]
        client.api.request(endpoint, token: client.token, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(ok: true)
            }){(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Reactions
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func addReaction(name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((reacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.ReactionsAdd, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(reacted: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func removeReaction(name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((unreacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.ReactionsRemove, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(unreacted: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func react(endpoint: SlackAPIEndpoint, name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["name":name, "file":file, "file_comment":fileComment, "channel":channel, "timestamp":timestamp]
        client.api.request(endpoint, token: client.token, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(ok: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Stars
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func addStar(file: String? = nil, fileComment: String? = nil, channel: String?  = nil, timestamp: String? = nil, success: ((starred: Bool)->Void)?, failure: FailureClosure?) {
        star(.StarsAdd, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(starred: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func removeStar(file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((unstarred: Bool)->Void)?, failure: FailureClosure?) {
        star(.StarsRemove, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {
            (ok) -> Void in
                success?(unstarred: ok)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func star(endpoint: SlackAPIEndpoint, file: String?, fileComment: String?, channel: String?, timestamp: String?, success: ((ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject?] = ["file":file, "file_comment":fileComment, "channel":channel, "timestamp":timestamp]
        client.api.request(endpoint, token: client.token, parameters: filterNilParameters(parameters), successClosure: {
            (response) -> Void in
                success?(ok: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }

    
    //MARK: - Team
    public func teamInfo(success: ((info: [String: AnyObject]?)->Void)?, failure: FailureClosure?) {
        client.api.request(.TeamInfo, token: client.token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(info: response["team"] as? [String: AnyObject])
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Users
    public func userPresence(user: String, success: ((presence: String?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["user":user]
        client.api.request(.UsersGetPresence, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(presence: response["presence"] as? String)
            }){(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func userInfo(id: String, success: ((user: User?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["user":id]
        client.api.request(.UsersInfo, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(user: User(user: response["user"] as? [String: AnyObject]))
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func usersList(includePresence: Bool = false, success: ((userList: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["presence":includePresence]
        client.api.request(.UsersList, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(userList: response["members"] as? [[String: AnyObject]])
            }){(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setUserActive(success: ((success: Bool)->Void)?, failure: FailureClosure?) {
        client.api.request(.UsersSetActive, token: client.token, parameters: nil, successClosure: {
            (response) -> Void in
                success?(success: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    public func setUserPresence(presence: Presence, success: ((success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["presence":presence.rawValue]
        client.api.request(.UsersSetPresence, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(success:true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    //MARK: - Channel Utilities
    private func close(endpoint: SlackAPIEndpoint, channelID: String, success: ((closed: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel":channelID]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(closed: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func history(endpoint: SlackAPIEndpoint, id: String, latest: String = "\(NSDate().timeIntervalSince1970)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((history: History?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel": id, "latest": latest, "oldest": oldest, "inclusive":inclusive, "count":count, "unreads":unreads]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(history: History(history: response))
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func info(endpoint: SlackAPIEndpoint, type: ChannelType, id: String, success: ((channel: Channel?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel": id]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(channel: Channel(channel: response[type.rawValue] as? [String: AnyObject]))
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func list(endpoint: SlackAPIEndpoint, type: ChannelType, excludeArchived: Bool = false, success: ((channels: [[String: AnyObject]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["exclude_archived": excludeArchived]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(channels: response[type.rawValue+"s"] as? [[String: AnyObject]])
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func mark(endpoint: SlackAPIEndpoint, channel: String, timestamp: String, success: ((ts: String)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel": channel, "ts": timestamp]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(ts: timestamp)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }
    
    private func setInfo(endpoint: SlackAPIEndpoint, type: InfoType, channel: String, text: String, success: ((success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: AnyObject] = ["channel": channel, type.rawValue: text]
        client.api.request(endpoint, token: client.token, parameters: parameters, successClosure: {
            (response) -> Void in
                success?(success: true)
            }) {(error) -> Void in
                failure?(error: error)
        }
    }

    //MARK: - Filter Nil Parameters
    private func filterNilParameters(parameters: [String: AnyObject?]) -> [String: AnyObject] {
        var finalParameters = [String: AnyObject]()
        for key in parameters.keys {
            if parameters[key] != nil {
                finalParameters[key] = parameters[key]!
            }
        }
        return finalParameters
    }
    
    private func encodeAttachments(attachments: [Attachment?]?) -> NSString? {
        if let attachments = attachments {
            var attachmentArray: [[String: AnyObject]] = []
            for attachment in attachments {
                if let attachment = attachment {
                    attachmentArray.append(attachment.dictionary())
                }
            }
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(attachmentArray, options: NSJSONWritingOptions.PrettyPrinted)
                let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                return string
            } catch _ {
                
            }
        }
        return nil
    }
    
}
