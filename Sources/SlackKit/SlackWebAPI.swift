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

internal enum Endpoint: String {
    case apiTest = "api.test"
    case authTest = "auth.test"
    case channelsHistory = "channels.history"
    case channelsInfo = "channels.info"
    case channelsList = "channels.list"
    case channelsMark = "channels.mark"
    case channelsSetPurpose = "channels.setPurpose"
    case channelsSetTopic = "channels.setTopic"
    case chatDelete = "chat.delete"
    case chatMeMessage = "chat.meMessage"
    case chatPostMessage = "chat.postMessage"
    case chatUpdate = "chat.update"
    case dndInfo = "dnd.info"
    case dndTeamInfo = "dnd.teamInfo"
    case emojiList = "emoji.list"
    case filesCommentsAdd = "files.comments.add"
    case filesCommentsEdit = "files.comments.edit"
    case filesCommentsDelete = "files.comments.delete"
    case filesDelete = "files.delete"
    case filesInfo = "files.info"
    case filesUpload = "files.upload"
    case groupsClose = "groups.close"
    case groupsHistory = "groups.history"
    case groupsInfo = "groups.info"
    case groupsList = "groups.list"
    case groupsMark = "groups.mark"
    case groupsOpen = "groups.open"
    case groupsSetPurpose = "groups.setPurpose"
    case groupsSetTopic = "groups.setTopic"
    case imClose = "im.close"
    case imHistory = "im.history"
    case imList = "im.list"
    case imMark = "im.mark"
    case imOpen = "im.open"
    case mpimClose = "mpim.close"
    case mpimHistory = "mpim.history"
    case mpimList = "mpim.list"
    case mpimMark = "mpim.mark"
    case mpimOpen = "mpim.open"
    case pinsAdd = "pins.add"
    case pinsRemove = "pins.remove"
    case reactionsAdd = "reactions.add"
    case reactionsGet = "reactions.get"
    case reactionsList = "reactions.list"
    case reactionsRemove = "reactions.remove"
    case rtmStart = "rtm.start"
    case starsAdd = "stars.add"
    case starsRemove = "stars.remove"
    case teamInfo = "team.info"
    case usersGetPresence = "users.getPresence"
    case usersInfo = "users.info"
    case usersList = "users.list"
    case usersSetActive = "users.setActive"
    case usersSetPresence = "users.setPresence"
}

public class SlackWebAPI {
    
    public typealias FailureClosure = (_ error: SlackError)->Void
    
    public enum InfoType: String {
        case purpose = "purpose"
        case topic = "topic"
    }
    
    public enum ParseMode: String {
        case full = "full"
        case none = "none"
    }
    
    public enum Presence: String {
        case auto = "auto"
        case away = "away"
    }
    
    private enum ChannelType: String {
        case channel = "channel"
        case group = "group"
        case im = "im"
    }
    
    private let networkInterface: NetworkInterface
    private let token: String
    
    public init(token: String) {
        self.networkInterface = NetworkInterface()
        self.token = token
    }
    
    //MARK: - RTM
    public func rtmStart(simpleLatest: Bool? = nil, noUnreads: Bool? = nil, mpimAware: Bool? = nil, success: ((_ response: [String: Any])->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "simple_latest": simpleLatest, "no_unreads": noUnreads, "mpim_aware": mpimAware]
        networkInterface.request(.rtmStart, parameters: parameters, successClosure: {(response) in
                success?(response)
            }) {(error) in
                failure?(error)
            }
    }
    
    //MARK: - Auth Test
    public func authenticationTest(success: ((_ authenticated: Bool)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.authTest, parameters: ["token": token], successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Channels
    public func channelHistory(id: String, latest: String = "\(Date().slackTimestamp)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History?)->Void)?, failure: FailureClosure?) {
        history(.channelsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {(history) in
                success?(history)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func channelInfo(id: String, success: ((_ channel: Channel)->Void)?, failure: FailureClosure?) {
        info(.channelsInfo, type:.channel, id: id, success: {(channel) in
                success?(channel)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func channelsList(excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.channelsList, type:.channel, excludeArchived: excludeArchived, success: {(channels) in
                success?(channels)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func markChannel(channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.channelsMark, channel: channel, timestamp: timestamp, success: {(ts) in
                success?(timestamp)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func setChannelPurpose(channel: String, purpose: String, success: ((_ purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.channelsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {(purposeSet) in
                success?(purposeSet)
            }) { (error) in
                failure?(error)
        }
    }
    
    public func setChannelTopic(channel: String, topic: String, success: ((_ topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.channelsSetTopic, type: .topic, channel: channel, text: topic, success: {(topicSet) in
                success?(topicSet)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Messaging
    public func deleteMessage(channel: String, ts: String, success: ((_ deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": channel, "ts": ts]
        networkInterface.request(.chatDelete, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func sendMessage(channel: String, text: String, username: String? = nil, asUser: Bool? = nil, parse: ParseMode? = nil, linkNames: Bool? = nil, attachments: [Attachment?]? = nil, unfurlLinks: Bool? = nil, unfurlMedia: Bool? = nil, iconURL: String? = nil, iconEmoji: String? = nil, success: (((ts: String?, channel: String?))->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "channel":channel, "text":text.slackFormatEscaping, "as_user":asUser, "parse":parse?.rawValue, "link_names":linkNames, "unfurl_links":unfurlLinks, "unfurlMedia":unfurlMedia, "username":username, "attachments":encodeAttachments(attachments), "icon_url":iconURL, "icon_emoji":iconEmoji]
        networkInterface.request(.chatPostMessage, parameters: parameters, successClosure: {(response) in
                success?((ts: response["ts"] as? String, response["channel"] as? String))
            }) {(error) in
                failure?(error)
        }
    }
    
    public func sendMeMessage(channel: String, text: String, success: (((ts: String?, channel: String?))->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "channel": channel, "text": text.slackFormatEscaping]
        networkInterface.request(.chatMeMessage, parameters: parameters, successClosure: {(response) in
            success?((ts: response["ts"] as? String, response["channel"] as? String))
        }) {(error) in
            failure?(error)
        }
    }
    
    public func updateMessage(channel: String, ts: String, message: String, attachments: [Attachment?]? = nil, parse:ParseMode = .none, linkNames: Bool = false, success: ((_ updated: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "channel": channel, "ts": ts, "text": message.slackFormatEscaping, "parse": parse.rawValue, "link_names": linkNames, "attachments":encodeAttachments(attachments)]
        networkInterface.request(.chatUpdate, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Do Not Disturb
    public func dndInfo(user: String? = nil, success: ((_ status: DoNotDisturbStatus)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "user": user]
        networkInterface.request(.dndInfo, parameters: parameters, successClosure: {(response) in
                success?(DoNotDisturbStatus(status: response))
            }) {(error) in
                failure?(error)
        }
    }
    
    public func dndTeamInfo(users: [String]? = nil, success: ((_ statuses: [String: DoNotDisturbStatus])->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "users": users?.joined(separator: ",")]
        networkInterface.request(.dndTeamInfo, parameters: parameters, successClosure: {(response) in
            guard let usersDictionary = response["users"] as? [String: Any] else {
                success?([:])
                return
            }
            success?(self.enumerateDNDStatuses(usersDictionary))
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Emoji
    public func emojiList(success: ((_ emojiList: [String: Any]?)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.emojiList, parameters: ["token": token], successClosure: {(response) in
                success?(response["emoji"] as? [String: Any])
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Files
    public func deleteFile(fileID: String, success: ((_ deleted: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "file": fileID]
        networkInterface.request(.filesDelete, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func fileInfo(_ fileID: String, commentCount: Int = 100, totalPages: Int = 1, success: ((_ file: File)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file": fileID, "count": commentCount, "totalPages": totalPages]
        networkInterface.request(.filesInfo, parameters: parameters, successClosure: {(response) in
            var file = File(file: response["file"] as? [String: Any])
            (response["comments"] as? [[String: Any]])?.forEach { comment in
                let comment = Comment(comment: comment)
                if let id = comment.id {
                    file.comments[id] = comment
                }
            }
            success?(file)
        }) {(error) in
            failure?(error)
        }
    }
    
    public func uploadFile(_ file: Data, filename: String, filetype: String = "auto", title: String? = nil, initialComment: String? = nil, channels: [String]? = nil, success: ((_ file: File)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "filename": filename, "filetype": filetype, "title": title, "initial_comment": initialComment, "channels": channels?.joined(separator: ",")]
        networkInterface.uploadRequest(data: file, parameters: parameters, successClosure: {(response) in
            success?(File(file: response["file"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }
    
    //MARK: - File Comments
    public func addFileComment(fileID: String, comment: String, success: ((_ comment: Comment)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file":fileID, "comment":comment.slackFormatEscaping]
        networkInterface.request(.filesCommentsAdd, parameters: parameters, successClosure: {(response) in
                success?(Comment(comment: response["comment"] as? [String: Any]))
            }) {(error) in
                failure?(error)
        }
    }
    
    public func editFileComment(fileID: String, commentID: String, comment: String, success: ((_ comment: Comment)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file":fileID, "id":commentID, "comment":comment.slackFormatEscaping]
        networkInterface.request(.filesCommentsEdit, parameters: parameters, successClosure: {(response) in
            success?(Comment(comment: response["comment"] as? [String: Any]))
            }) {(error) in
                failure?(error)
        }
    }
    
    public func deleteFileComment(fileID: String, commentID: String, success: ((_ deleted: Bool?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file":fileID, "id": commentID]
        networkInterface.request(.filesCommentsDelete, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Groups
    public func closeGroup(groupID: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.groupsClose, channelID: groupID, success: {(closed) in
                success?(closed)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func groupHistory(id: String, latest: String = "\(Date().slackTimestamp)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History?)->Void)?, failure: FailureClosure?) {
        history(.groupsHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {(history) in
                success?(history)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func groupInfo(id: String, success: ((_ channel: Channel?)->Void)?, failure: FailureClosure?) {
        info(.groupsInfo, type:.group, id: id, success: {(channel) in
                success?(channel)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func groupsList(excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.groupsList, type:.group, excludeArchived: excludeArchived, success: {(channels) in
                success?(channels)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func markGroup(channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.groupsMark, channel: channel, timestamp: timestamp, success: {(ts) in
                success?(timestamp)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func openGroup(channel: String, success: ((_ opened: Bool)->Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "channel":channel]
        networkInterface.request(.groupsOpen, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func setGroupPurpose(channel: String, purpose: String, success: ((_ purposeSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.groupsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {(purposeSet) in
                success?(purposeSet)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func setGroupTopic(channel: String, topic: String, success: ((_ topicSet: Bool)->Void)?, failure: FailureClosure?) {
        setInfo(.groupsSetTopic, type: .topic, channel: channel, text: topic, success: {(topicSet) in
                success?(topicSet)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - IM
    public func closeIM(channel: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.imClose, channelID: channel, success: {(closed) in
                success?(closed)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func imHistory(id: String, latest: String = "\(Date().slackTimestamp)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History?)->Void)?, failure: FailureClosure?) {
        history(.imHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {(history) in
                success?(history)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func imsList(excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.imList, type:.im, excludeArchived: excludeArchived, success: {(channels) in
                success?(channels)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func markIM(channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.imMark, channel: channel, timestamp: timestamp, success: {(ts) in
                success?(timestamp)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func openIM(userID: String, success: ((_ imID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "user":userID]
        networkInterface.request(.imOpen, parameters: parameters, successClosure: {(response) in
                let group = response["channel"] as? [String: Any]
                success?(group?["id"] as? String)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - MPIM
    public func closeMPIM(channel: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        close(.mpimClose, channelID: channel, success: {(closed) in
                success?(closed)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func mpimHistory(id: String, latest: String = "\(Date().slackTimestamp)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History?)->Void)?, failure: FailureClosure?) {
        history(.mpimHistory, id: id, latest: latest, oldest: oldest, inclusive: inclusive, count: count, unreads: unreads, success: {(history) in
                success?(history)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func mpimsList(excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        list(.mpimList, type:.group, excludeArchived: excludeArchived, success: {(channels) in
                success?(channels)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func markMPIM(channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        mark(.mpimMark, channel: channel, timestamp: timestamp, success: {(ts) in
                success?(timestamp)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func openMPIM(userIDs: [String], success: ((_ mpimID: String?)->Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "users":userIDs.joined(separator: ",")]
        networkInterface.request(.mpimOpen, parameters: parameters, successClosure: {(response) in
                let group = response["group"] as? [String: Any]
                success?(group?["id"] as? String)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Pins
    public func pinItem(channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ pinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.pinsAdd, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func unpinItem(channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ unpinned: Bool)->Void)?, failure: FailureClosure?) {
        pin(.pinsRemove, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    private func pin(_ endpoint: Endpoint, channel: String, file: String? = nil, fileComment: String? = nil, timestamp: String? = nil, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "channel":channel, "file":file, "file_comment":fileComment, "timestamp":timestamp]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Reactions
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func addReaction(name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ reacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.reactionsAdd, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    // One of file, file_comment, or the combination of channel and timestamp must be specified.
    public func removeReaction(name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ unreacted: Bool)->Void)?, failure: FailureClosure?) {
        react(.reactionsRemove, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    private func react(_ endpoint: Endpoint, name: String, file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "name":name, "file":file, "file_comment":fileComment, "channel":channel, "timestamp":timestamp]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Stars
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func addStar(file: String? = nil, fileComment: String? = nil, channel: String?  = nil, timestamp: String? = nil, success: ((_ starred: Bool)->Void)?, failure: FailureClosure?) {
        star(.starsAdd, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    // One of file, file_comment, channel, or the combination of channel and timestamp must be specified.
    public func removeStar(file: String? = nil, fileComment: String? = nil, channel: String? = nil, timestamp: String? = nil, success: ((_ unstarred: Bool)->Void)?, failure: FailureClosure?) {
        star(.starsRemove, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
                success?(ok)
            }) {(error) in
                failure?(error)
        }
    }
    
    private func star(_ endpoint: Endpoint, file: String?, fileComment: String?, channel: String?, timestamp: String?, success: ((_ ok: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "file":file, "file_comment":fileComment, "channel":channel, "timestamp":timestamp]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }

    
    //MARK: - Team
    public func teamInfo(success: ((_ info: [String: Any]?)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.teamInfo, parameters: ["token": token], successClosure: {(response) in
                success?(response["team"] as? [String: Any])
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Users
    public func userPresence(user: String, success: ((_ presence: String?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "user":user]
        networkInterface.request(.usersGetPresence, parameters: parameters, successClosure: {(response) in
                success?(response["presence"] as? String)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func userInfo(id: String, success: ((_ user: User)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "user":id]
        networkInterface.request(.usersInfo, parameters: parameters, successClosure: {(response) in
                success?(User(user: response["user"] as? [String: Any]))
            }) {(error) in
                failure?(error)
        }
    }
    
    public func usersList(includePresence: Bool = false, success: ((_ userList: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "presence":includePresence]
        networkInterface.request(.usersList, parameters: parameters, successClosure: {(response) in
                success?(response["members"] as? [[String: Any]])
            }) {(error) in
                failure?(error)
        }
    }
    
    public func setUserActive(success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        networkInterface.request(.usersSetActive, parameters: ["token": token], successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    public func setUserPresence(presence: Presence, success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "presence":presence.rawValue]
        networkInterface.request(.usersSetPresence, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Channel Utilities
    private func close(_ endpoint: Endpoint, channelID: String, success: ((_ closed: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel":channelID]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    private func history(_ endpoint: Endpoint, id: String, latest: String = "\(Date().slackTimestamp)", oldest: String = "0", inclusive: Bool = false, count: Int = 100, unreads: Bool = false, success: ((_ history: History)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": id, "latest": latest, "oldest": oldest, "inclusive":inclusive, "count":count, "unreads":unreads]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(History(history: response))
            }) {(error) in
                failure?(error)
        }
    }
    
    private func info(_ endpoint: Endpoint, type: ChannelType, id: String, success: ((_ channel: Channel)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": id]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(Channel(channel: response[type.rawValue] as? [String: Any]))
            }) {(error) in
                failure?(error)
        }
    }
    
    private func list(_ endpoint: Endpoint, type: ChannelType, excludeArchived: Bool = false, success: ((_ channels: [[String: Any]]?)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "exclude_archived": excludeArchived]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(response[type.rawValue+"s"] as? [[String: Any]])
            }) {(error) in
                failure?(error)
        }
    }
    
    private func mark(_ endpoint: Endpoint, channel: String, timestamp: String, success: ((_ ts: String)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": channel, "ts": timestamp]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(timestamp)
            }) {(error) in
                failure?(error)
        }
    }
    
    private func setInfo(_ endpoint: Endpoint, type: InfoType, channel: String, text: String, success: ((_ success: Bool)->Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": channel, type.rawValue: text]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
                success?(true)
            }) {(error) in
                failure?(error)
        }
    }
    
    //MARK: - Encode Attachments
    private func encodeAttachments(_ attachments: [Attachment?]?) -> String? {
        if let attachments = attachments {
            var attachmentArray: [[String: Any]] = []
            for attachment in attachments {
                if let attachment = attachment {
                    attachmentArray.append(attachment.dictionary)
                }
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: attachmentArray, options: [])
                return String(data: data, encoding: String.Encoding.utf8)
            } catch _ {
                print("Error encoding attachments")
            }
        }
        return nil
    }
    
    //MARK: - Enumerate Do Not Disturb Status
    private func enumerateDNDStatuses(_ statuses: [String: Any]) -> [String: DoNotDisturbStatus] {
        var retVal = [String: DoNotDisturbStatus]()
        for key in statuses.keys {
            retVal[key] = DoNotDisturbStatus(status: statuses[key] as? [String: Any])
        }
        return retVal
    }
}
