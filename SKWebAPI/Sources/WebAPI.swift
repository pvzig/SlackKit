//
// WebAPI.swift
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

//swiftlint:disable file_length
import Foundation
@_exported import SKCore

public final class WebAPI {

    public typealias SuccessClosure = (_ success: Bool) -> Void
    public typealias FailureClosure = (_ error: SlackError) -> Void
    public typealias CommentClosure = (_ comment: Comment) -> Void
    public typealias ChannelClosure = (_ channel: Channel) -> Void
    public typealias MessageClosure = (_ message: Message) -> Void
    public typealias HistoryClosure = (_ history: History) -> Void
    public typealias FileClosure = (_ file: File) -> Void
    public typealias ItemsClosure = (_ items: [Item]?) -> Void
    public typealias AuthTestClosure = (_ user: String?, _ team: String?) -> Void

    public enum InfoType: String {
        case purpose, topic
    }

    public enum ParseMode: String {
        case full, none
    }

    public enum Presence: String {
        case auto, away
    }

    fileprivate enum ChannelType: String {
        case channel, group, im
    }

    public enum ConversationType: String {
        case public_channel, private_channel, mpim, im
    }

    fileprivate let networkInterface: NetworkInterface
    fileprivate let token: String

    public init(token: String) {
        self.networkInterface = NetworkInterface()
        self.token = token
    }
}

// MARK: - RTM
extension WebAPI {
    public static func rtmStart(
        token: String,
        batchPresenceAware: Bool = false,
        mpimAware: Bool? = nil,
        noLatest: Bool = false,
        noUnreads: Bool? = nil,
        presenceSub: Bool = false,
        simpleLatest: Bool? = nil,
        success: ((_ response: [String: Any]) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] =
            [
                "token": token,
                "batch_presence_aware": batchPresenceAware,
                "mpim_aware": mpimAware,
                "no_latest": noLatest,
                "no_unreads": noUnreads,
                "presence_sub": presenceSub,
                "simple_latest": simpleLatest
        ]
        NetworkInterface().request(.rtmStart, parameters: parameters, successClosure: {(response) in
            success?(response)
        }) {(error) in
            failure?(error)
        }
    }

    public static func rtmConnect(
        token: String,
        batchPresenceAware: Bool = false,
        presenceSub: Bool = false,
        success: ((_ response: [String: Any]) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] =
            [
                "token": token,
                "batch_presence_aware": batchPresenceAware,
                "presence_sub": presenceSub
            ]
        NetworkInterface().request(.rtmConnect, parameters: parameters, successClosure: {(response) in
            success?(response)
        }) {(error) in
            failure?(error)
        }

    }
}

// MARK: - Auth
extension WebAPI {
    public func authenticationTest(success: AuthTestClosure?, failure: FailureClosure?) {
        networkInterface.request(.authTest, parameters: ["token": token], successClosure: { (response) in
            success?(response["user_id"] as? String, response["team_id"] as? String)
        }) {(error) in
            failure?(error)
        }
    }

    public static func oauthAccess(clientID: String, clientSecret: String, code: String, redirectURI: String? = nil) -> [String: Any]? {
        let parameters: [String: Any?] = ["client_id": clientID, "client_secret": clientSecret, "code": code, "redirect_uri": redirectURI]
        return NetworkInterface().synchronusRequest(.oauthAccess, parameters: parameters)
    }

    public static func oauthRevoke(
        token: String,
        test: Bool? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = ["token": token, "test": test]
        NetworkInterface().request(.authRevoke, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Channels
extension WebAPI {
    public func channelHistory(
        id: String,
        latest: String = "\(Date().timeIntervalSince1970)",
        oldest: String = "0", inclusive: Bool = false,
        count: Int = 100, unreads: Bool = false,
        success: HistoryClosure?,
        failure: FailureClosure?
    ) {
        history(.channelsHistory,
                id: id,
                latest: latest,
                oldest: oldest,
                inclusive: inclusive,
                count: count,
                unreads: unreads,
                success: {(history) in
                    success?(history)
        }) {(error) in
            failure?(error)
        }
    }

    public func channelInfo(id: String, success: ChannelClosure?, failure: FailureClosure?) {
        info(.channelsInfo, type:.channel, id: id, success: {(channel) in
            success?(channel)
        }) {(error) in
            failure?(error)
        }
    }

    public func channelsList(
        excludeArchived: Bool = false,
        excludeMembers: Bool = false,
        success: ((_ channels: [[String: Any]]?) -> Void)?,
        failure: FailureClosure?
    ) {
        list(.channelsList, type:.channel, excludeArchived: excludeArchived, excludeMembers: excludeMembers, success: {(channels) in
            success?(channels)
        }) {(error) in
            failure?(error)
        }
    }

    public func markChannel(channel: String, timestamp: String, success: ((_ ts: String) -> Void)?, failure: FailureClosure?) {
        mark(.channelsMark, channel: channel, timestamp: timestamp, success: {(ts) in
            success?(ts)
        }) {(error) in
            failure?(error)
        }
    }

    public func createChannel(channel: String, success: ChannelClosure?, failure: FailureClosure?) {
        create(.channelsCreate, name: channel, success: success, failure: failure)
    }

    public func inviteToChannel(_ channel: String, user: String, success: SuccessClosure?, failure: FailureClosure?) {
        invite(.channelsInvite, channel: channel, user: user, success: success, failure: failure)
    }

    public func setChannelPurpose(channel: String, purpose: String, success: SuccessClosure?, failure: FailureClosure?) {
        setInfo(.channelsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {(purposeSet) in
            success?(purposeSet)
        }) {(error) in
            failure?(error)
        }
    }

    public func setChannelTopic(channel: String, topic: String, success: SuccessClosure?, failure: FailureClosure?) {
        setInfo(.channelsSetTopic, type: .topic, channel: channel, text: topic, success: {(topicSet) in
            success?(topicSet)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Messaging
extension WebAPI {
    public func deleteMessage(channel: String, ts: String, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": channel, "ts": ts]
        networkInterface.request(.chatDelete, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    public func sendMessage(
        channel: String,
        text: String,
        username: String? = nil,
        asUser: Bool? = nil,
        parse: ParseMode? = nil,
        linkNames: Bool? = nil,
        attachments: [Attachment?]? = nil,
        unfurlLinks: Bool? = nil,
        unfurlMedia: Bool? = nil,
        iconURL: String? = nil,
        iconEmoji: String? = nil,
        success: (((ts: String?, channel: String?)) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "channel": channel,
            "text": text,
            "as_user": asUser,
            "parse": parse?.rawValue,
            "link_names": linkNames,
            "unfurl_links": unfurlLinks,
            "unfurlMedia": unfurlMedia,
            "username": username,
            "icon_url": iconURL,
            "icon_emoji": iconEmoji,
            "attachments": encodeAttachments(attachments)
        ]
        networkInterface.request(.chatPostMessage, parameters: parameters, successClosure: {(response) in
            success?((ts: response["ts"] as? String, response["channel"] as? String))
        }) {(error) in
            failure?(error)
        }
    }

    public func sendThreadedMessage(
        channel: String,
        thread: String,
        text: String,
        broadcastReply: Bool = false,
        username: String? = nil,
        asUser: Bool? = nil,
        parse: ParseMode? = nil,
        linkNames: Bool? = nil,
        attachments: [Attachment?]? = nil,
        unfurlLinks: Bool? = nil,
        unfurlMedia: Bool? = nil,
        iconURL: String? = nil,
        iconEmoji: String? = nil,
        success: (((ts: String?, channel: String?)) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "channel": channel,
            "thread_ts": thread,
            "text": text,
            "broadcastReply": broadcastReply,
            "as_user": asUser,
            "parse": parse?.rawValue,
            "link_names": linkNames,
            "unfurl_links": unfurlLinks,
            "unfurlMedia": unfurlMedia,
            "username": username,
            "icon_url": iconURL,
            "icon_emoji": iconEmoji,
            "attachments": encodeAttachments(attachments)
        ]
        networkInterface.request(.chatPostMessage, parameters: parameters, successClosure: {(response) in
            success?((ts: response["ts"] as? String, response["channel"] as? String))
        }) {(error) in
            failure?(error)
        }
    }

    public func sendMeMessage(
        channel: String,
        text: String,
        success: (((ts: String?, channel: String?)) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = ["token": token, "channel": channel, "text":  text]
        networkInterface.request(.chatMeMessage, parameters: parameters, successClosure: {(response) in
            success?((ts: response["ts"] as? String, response["channel"] as? String))
        }) {(error) in
            failure?(error)
        }
    }

    public func updateMessage(
        channel: String,
        ts: String,
        message: String,
        attachments: [Attachment?]? = nil,
        parse: ParseMode = .none,
        linkNames: Bool = false,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "channel": channel,
            "ts": ts,
            "text": message,
            "parse": parse.rawValue,
            "link_names": linkNames,
            "attachments": encodeAttachments(attachments)
        ]
        networkInterface.request(.chatUpdate, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Do Not Disturb
extension WebAPI {
    public func dndInfo(user: String? = nil, success: ((_ status: DoNotDisturbStatus) -> Void)?, failure: FailureClosure?) {
        let parameters: [String: Any?] = ["token": token, "user": user]
        networkInterface.request(.dndInfo, parameters: parameters, successClosure: {(response) in
            success?(DoNotDisturbStatus(status: response))
        }) {(error) in
            failure?(error)
        }
    }

    public func dndTeamInfo(
        users: [String]? = nil,
        success: ((_ statuses: [String: DoNotDisturbStatus]) -> Void)?,
        failure: FailureClosure?
    ) {
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
}

// MARK: - Emoji
extension WebAPI {
    public func emojiList(success: ((_ emojiList: [String: Any]?) -> Void)?, failure: FailureClosure?) {
        networkInterface.request(.emojiList, parameters: ["token": token], successClosure: {(response) in
            success?(response["emoji"] as? [String: Any])
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Files
extension WebAPI {
    public func deleteFile(fileID: String, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters = ["token": token, "file": fileID]
        networkInterface.request(.filesDelete, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    public func fileInfo(
        fileID: String,
        commentCount: Int = 100,
        totalPages: Int = 1,
        success: FileClosure?,
        failure: FailureClosure?
    ) {
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

    public func uploadFile(
        file: Data,
        filename: String,
        filetype: String = "auto",
        title: String? = nil,
        initialComment: String? = nil,
        channels: [String]? = nil,
        success: FileClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "filename": filename,
            "filetype": filetype,
            "title": title,
            "initial_comment": initialComment,
            "channels": channels?.joined(separator: ",")
        ]
        networkInterface.uploadRequest(data: file, parameters: parameters, successClosure: {(response) in
            success?(File(file: response["file"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - File Comments
extension WebAPI {
    public func addFileComment(fileID: String, comment: String, success: CommentClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file": fileID, "comment": comment]
        networkInterface.request(.filesCommentsAdd, parameters: parameters, successClosure: {(response) in
            success?(Comment(comment: response["comment"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }

    public func editFileComment(fileID: String, commentID: String, comment: String, success: CommentClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file": fileID, "id": commentID, "comment": comment]
        networkInterface.request(.filesCommentsEdit, parameters: parameters, successClosure: {(response) in
            success?(Comment(comment: response["comment"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }

    public func deleteFileComment(fileID: String, commentID: String, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "file": fileID, "id": commentID]
        networkInterface.request(.filesCommentsDelete, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Groups
extension WebAPI {
    public func closeGroup(groupID: String, success: SuccessClosure?, failure: FailureClosure?) {
        close(.groupsClose, channelID: groupID, success: {(closed) in
            success?(closed)
        }) {(error) in
            failure?(error)
        }
    }

    public func groupHistory(
        id: String,
        latest: String = "\(Date().timeIntervalSince1970)",
        oldest: String = "0",
        inclusive: Bool = false,
        count: Int = 100,
        unreads: Bool = false,
        success: HistoryClosure?,
        failure: FailureClosure?
    ) {
        history(.groupsHistory,
                id: id,
                latest: latest,
                oldest: oldest,
                inclusive: inclusive,
                count: count,
                unreads: unreads,
                success: {(history) in
                    success?(history)
        }) {(error) in
            failure?(error)
        }
    }

    public func groupInfo(id: String, success: ChannelClosure?, failure: FailureClosure?) {
        info(.groupsInfo, type:.group, id: id, success: {(channel) in
            success?(channel)
        }) {(error) in
            failure?(error)
        }
    }

    public func groupsList(
        excludeArchived: Bool = false,
        excludeMembers: Bool = false,
        success: ((_ channels: [[String: Any]]?) -> Void)?,
        failure: FailureClosure?
    ) {
        list(.groupsList, type:.group, excludeArchived: excludeArchived, excludeMembers: excludeMembers, success: {(channels) in
            success?(channels)
        }) {(error) in
            failure?(error)
        }
    }

    public func markGroup(channel: String, timestamp: String, success: ((_ ts: String) -> Void)?, failure: FailureClosure?) {
        mark(.groupsMark, channel: channel, timestamp: timestamp, success: {(ts) in
            success?(ts)
        }) {(error) in
            failure?(error)
        }
    }

    public func openGroup(channel: String, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters = ["token": token, "channel": channel]
        networkInterface.request(.groupsOpen, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    public func setGroupPurpose(channel: String, purpose: String, success: SuccessClosure?, failure: FailureClosure?) {
        setInfo(.groupsSetPurpose, type: .purpose, channel: channel, text: purpose, success: {(purposeSet) in
            success?(purposeSet)
        }) {(error) in
            failure?(error)
        }
    }

    public func setGroupTopic(channel: String, topic: String, success: SuccessClosure?, failure: FailureClosure?) {
        setInfo(.groupsSetTopic, type: .topic, channel: channel, text: topic, success: {(topicSet) in
            success?(topicSet)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - IM
extension WebAPI {
    public func closeIM(channel: String, success: SuccessClosure?, failure: FailureClosure?) {
        close(.imClose, channelID: channel, success: {(closed) in
            success?(closed)
        }) {(error) in
            failure?(error)
        }
    }

    public func imHistory(
        id: String,
        latest: String = "\(Date().timeIntervalSince1970)",
        oldest: String = "0",
        inclusive: Bool = false,
        count: Int = 100,
        unreads: Bool = false,
        success: HistoryClosure?,
        failure: FailureClosure?
    ) {
        history(.imHistory,
                id: id,
                latest: latest,
                oldest: oldest,
                inclusive: inclusive,
                count: count,
                unreads: unreads,
                success: {(history) in
                    success?(history)
        }) {(error) in
            failure?(error)
        }
    }

    public func imsList(
        excludeArchived: Bool = false,
        excludeMembers: Bool = false,
        success: ((_ channels: [[String: Any]]?) -> Void)?,
        failure: FailureClosure?
    ) {
        list(.imList, type:.im, excludeArchived: excludeArchived, excludeMembers: excludeMembers, success: {(channels) in
            success?(channels)
        }) {(error) in
            failure?(error)
        }
    }

    public func markIM(channel: String, timestamp: String, success: ((_ ts: String) -> Void)?, failure: FailureClosure?) {
        mark(.imMark, channel: channel, timestamp: timestamp, success: {(ts) in
            success?(ts)
        }) {(error) in
            failure?(error)
        }
    }

    public func openIM(userID: String, success: ((_ imID: String?) -> Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "user": userID]
        networkInterface.request(.imOpen, parameters: parameters, successClosure: {(response) in
            let group = response["channel"] as? [String: Any]
            success?(group?["id"] as? String)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - MPIM
extension WebAPI {
    public func closeMPIM(channel: String, success: SuccessClosure?, failure: FailureClosure?) {
        close(.mpimClose, channelID: channel, success: {(closed) in
            success?(closed)
        }) {(error) in
            failure?(error)
        }
    }

    public func mpimHistory(
        id: String,
        latest: String = "\(Date().timeIntervalSince1970)",
        oldest: String = "0",
        inclusive: Bool = false,
        count: Int = 100,
        unreads: Bool = false,
        success: HistoryClosure?,
        failure: FailureClosure?
    ) {
        history(.mpimHistory,
                id: id,
                latest: latest,
                oldest: oldest,
                inclusive: inclusive,
                count: count,
                unreads: unreads,
                success: {(history) in
                    success?(history)
        }) {(error) in
            failure?(error)
        }
    }

    public func mpimsList(
        excludeArchived: Bool = false,
        excludeMembers: Bool = false,
        success: ((_ channels: [[String: Any]]?) -> Void)?,
        failure: FailureClosure?
    ) {
        list(.mpimList, type:.group, excludeArchived: excludeArchived, excludeMembers: excludeMembers, success: {(channels) in
            success?(channels)
        }) {(error) in
            failure?(error)
        }
    }

    public func markMPIM(channel: String, timestamp: String, success: ((_ ts: String) -> Void)?, failure: FailureClosure?) {
        mark(.mpimMark, channel: channel, timestamp: timestamp, success: {(ts) in
            success?(ts)
        }) {(error) in
            failure?(error)
        }
    }

    public func openMPIM(userIDs: [String], success: ((_ mpimID: String?) -> Void)?, failure: FailureClosure?) {
        let parameters = ["token": token, "users": userIDs.joined(separator: ",")]
        networkInterface.request(.mpimOpen, parameters: parameters, successClosure: {(response) in
            let group = response["group"] as? [String: Any]
            success?(group?["id"] as? String)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Pins
extension WebAPI {
    public func pinsList(
        channel: String,
        success: ItemsClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "channel": channel
        ]
        networkInterface.request(.pinsList, parameters: parameters, successClosure: { response in
            let items = response["items"] as? [[String: Any]]
            success?(items?.map({ Item(item: $0) }))
        }) {(error) in
            failure?(error)
        }
    }

    public func pinItem(
        channel: String,
        file: String? = nil,
        fileComment: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        pin(.pinsAdd, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    public func unpinItem(
        channel: String,
        file: String? = nil,
        fileComment: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        pin(.pinsRemove, channel: channel, file: file, fileComment: fileComment, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    private func pin(
        _ endpoint: Endpoint,
        channel: String,
        file: String? = nil,
        fileComment: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "channel": channel,
            "file": file,
            "file_comment": fileComment,
            "timestamp": timestamp
        ]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Reactions
extension WebAPI {
    public func addReactionToMessage(name: String, channel: String, timestamp: String, success: SuccessClosure?, failure: FailureClosure?) {
        addReaction(name: name, channel: channel, timestamp: timestamp, success: success, failure: failure)
    }

    public func addReactionToFile(name: String, file: String, success: SuccessClosure?, failure: FailureClosure?) {
        addReaction(name: name, file: file, success: success, failure: failure)
    }

    public func addReactionToFileComment(name: String, fileComment: String, success: SuccessClosure?, failure: FailureClosure?) {
        addReaction(name: name, fileComment: fileComment, success: success, failure: failure)
    }

    private func addReaction(
        name: String,
        file: String? = nil,
        fileComment: String? = nil,
        channel: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        react(.reactionsAdd, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    public func removeReactionFromMessage(
        name: String,
        channel: String,
        timestamp: String,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        removeReaction(name: name, channel: channel, timestamp: timestamp, success: success, failure: failure)
    }

    public func removeReactionFromFile(name: String, file: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeReaction(name: name, file: file, success: success, failure: failure)
    }

    public func removeReactionFromFileComment(name: String, fileComment: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeReaction(name: name, fileComment: fileComment, success: success, failure: failure)
    }

    private func removeReaction(
        name: String,
        file: String? = nil,
        fileComment: String? = nil,
        channel: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        react(.reactionsRemove, name: name, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    private func react(
        _ endpoint: Endpoint,
        name: String,
        file: String? = nil,
        fileComment: String? = nil,
        channel: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "name": name,
            "file": file,
            "file_comment": fileComment,
            "channel": channel,
            "timestamp": timestamp
        ]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    private enum ReactionItemType: String {
        case file, comment, message
    }

    public func getReactionsForFile(_ file: String, full: Bool = true, reactions: (([Reaction]) -> Void)?, failure: FailureClosure?) {
        getReactionsForItem(file, full: full, type: .file, reactions: reactions, failure: failure)
    }

    public func getReactionsForComment(_ comment: String, full: Bool = true, reactions: (([Reaction]) -> Void)?, failure: FailureClosure?) {
        getReactionsForItem(comment: comment, full: full, type: .comment, reactions: reactions, failure: failure)
    }

    public func getReactionsForMessage(
        _ channel: String,
        timestamp: String,
        full: Bool = true,
        reactions: (([Reaction]) -> Void)?,
        failure: FailureClosure?
    ) {
        getReactionsForItem(channel: channel, timestamp: timestamp, full: full, type: .message, reactions: reactions, failure: failure)
    }

    private func getReactionsForItem(
        _ file: String? = nil,
        comment: String? = nil,
        channel: String? = nil,
        timestamp: String? = nil,
        full: Bool,
        type: ReactionItemType,
        reactions: (([Reaction]) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "file": file,
            "file_comment": comment,
            "channel": channel,
            "timestamp": timestamp,
            "full": full
        ]
        networkInterface.request(.reactionsGet, parameters: parameters, successClosure: {(response) in
            guard let item = response[type.rawValue] as? [String: Any] else {
                reactions?([])
                return
            }
            switch type {
            case .message:
                let message = Message(dictionary: item)
                reactions?(message.reactions)
            case .file:
                let file = File(file: item)
                reactions?(file.reactions)
            case .comment:
                let comment = Comment(comment: item)
                reactions?(comment.reactions)
            }
        }) {(error) in
            failure?(error)
        }
    }

    public func reactionsListForUser(
        _ user: String? = nil,
        full: Bool = true,
        count: Int = 100,
        page: Int = 1,
        success: ItemsClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "user": user,
            "full": full,
            "count": count,
            "page": page
        ]
        networkInterface.request(.reactionsList, parameters: parameters, successClosure: {(response) in
            let items = response["items"] as? [[String: Any]]
            success?(items?.map({ Item(item: $0) }))
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Stars
extension WebAPI {
    public func addStarToChannel(channel: String, success: SuccessClosure?, failure: FailureClosure?) {
        addStar(channel: channel, success: success, failure: failure)
    }

    public func addStarToMessage(channel: String, timestamp: String, success: SuccessClosure?, failure: FailureClosure?) {
        addStar(channel: channel, timestamp: timestamp, success: success, failure: failure)
    }

    public func addStarToFile(file: String, success: SuccessClosure?, failure: FailureClosure?) {
        addStar(file: file, success: success, failure: failure)
    }

    public func addStarToFileComment(fileComment: String, success: SuccessClosure?, failure: FailureClosure?) {
        addStar(fileComment: fileComment, success: success, failure: failure)
    }

    private func addStar(
        file: String? = nil,
        fileComment: String? = nil,
        channel: String?  = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        star(.starsAdd, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    public func removeStarFromChannel(channel: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeStar(channel: channel, success: success, failure: failure)
    }

    public func removeStarFromMessage(channel: String, timestamp: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeStar(channel: channel, timestamp: timestamp, success: success, failure: failure)
    }

    public func removeStarFromFile(file: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeStar(file: file, success: success, failure: failure)
    }

    public func removeStarFromFilecomment(fileComment: String, success: SuccessClosure?, failure: FailureClosure?) {
        removeStar(fileComment: fileComment, success: success, failure: failure)
    }

    private func removeStar(
        file: String? = nil,
        fileComment: String? = nil,
        channel: String? = nil,
        timestamp: String? = nil,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        star(.starsRemove, file: file, fileComment: fileComment, channel: channel, timestamp: timestamp, success: {(ok) in
            success?(ok)
        }) {(error) in
            failure?(error)
        }
    }

    private func star(
        _ endpoint: Endpoint,
        file: String?,
        fileComment: String?,
        channel: String?,
        timestamp: String?,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any?] = [
            "token": token,
            "file": file,
            "file_comment": fileComment,
            "channel": channel,
            "timestamp": timestamp
        ]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Team
extension WebAPI {
    public func teamInfo(success: ((_ info: [String: Any]?) -> Void)?, failure: FailureClosure?) {
        networkInterface.request(.teamInfo, parameters: ["token": token], successClosure: {(response) in
            success?(response["team"] as? [String: Any])
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Users
extension WebAPI {
    public func userPresence(user: String, success: ((_ presence: String?) -> Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "user": user]
        networkInterface.request(.usersGetPresence, parameters: parameters, successClosure: {(response) in
            success?(response["presence"] as? String)
        }) {(error) in
            failure?(error)
        }
    }

    public func userInfo(id: String, success: ((_ user: User) -> Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "user": id]
        networkInterface.request(.usersInfo, parameters: parameters, successClosure: {(response) in
            success?(User(user: response["user"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }

    public func usersList(includePresence: Bool = false, success: ((_ userList: [[String: Any]]?) -> Void)?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "presence": includePresence]
        networkInterface.request(.usersList, parameters: parameters, successClosure: {(response) in
            success?(response["members"] as? [[String: Any]])
        }) {(error) in
            failure?(error)
        }
    }

    public func setUserActive(success: SuccessClosure?, failure: FailureClosure?) {
        networkInterface.request(.usersSetActive, parameters: ["token": token], successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    public func setUserPresence(presence: Presence, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "presence": presence.rawValue]
        networkInterface.request(.usersSetPresence, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Conversations
extension WebAPI {
    public func conversationsList(
        excludeArchived: Bool = false,
        cursor: String? = nil,
        limit: Int? = nil,
        types: [ConversationType]? = nil,
        success: ((_ channels: [[String: Any]]?, _ nextCursor: String?) -> Void)?,
        failure: FailureClosure?
    ) {
        var parameters: [String: Any] = ["token": token, "exclude_archived": excludeArchived]
        if let cursor = cursor {
            parameters["cursor"] = cursor
        }
        if let limit = limit {
            parameters["limit"] = limit
        }
        if let types = types {
            parameters["types"] = types.map({ $0.rawValue }).joined(separator: ",")
        }
        networkInterface.request(.conversationsList, parameters: parameters, successClosure: {(response) in
            success?(response["channels"] as? [[String: Any]], (response["response_metadata"] as? [String: Any])?["next_cursor"] as? String)
        }) {(error) in
            failure?(error)
        }
    }
}

// MARK: - Utilities
extension WebAPI {
    fileprivate func encodeAttachments(_ attachments: [Attachment?]?) -> String? {
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
            } catch let error {
                print(error)
            }
        }
        return nil
    }

    fileprivate func enumerateDNDStatuses(_ statuses: [String: Any]) -> [String: DoNotDisturbStatus] {
        var retVal = [String: DoNotDisturbStatus]()
        for key in statuses.keys {
            retVal[key] = DoNotDisturbStatus(status: statuses[key] as? [String: Any])
        }
        return retVal
    }

    fileprivate func close(_ endpoint: Endpoint, channelID: String, success: SuccessClosure?, failure: FailureClosure?) {
        let parameters: [String: Any] = ["token": token, "channel": channelID]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func history(
        _ endpoint: Endpoint,
        id: String,
        latest: String = "\(Date().timeIntervalSince1970)",
        oldest: String = "0",
        inclusive: Bool = false,
        count: Int = 100,
        unreads: Bool = false,
        success: HistoryClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = [
            "token": token,
            "channel": id,
            "latest": latest,
            "oldest": oldest,
            "inclusive": inclusive,
            "count": count,
            "unreads": unreads
        ]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
            success?(History(history: response))
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func info(
        _ endpoint: Endpoint,
        type: ChannelType,
        id: String,
        success: ChannelClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "channel": id]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
            success?(Channel(channel: response[type.rawValue] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func list(
        _ endpoint: Endpoint,
        type: ChannelType,
        excludeArchived: Bool = false,
        excludeMembers: Bool = false,
        success: ((_ channels: [[String: Any]]?) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "exclude_archived": excludeArchived, "exclude_members": excludeMembers]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
            success?(response[type.rawValue+"s"] as? [[String: Any]])
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func mark(
        _ endpoint: Endpoint,
        channel: String,
        timestamp: String,
        success: ((_ ts: String) -> Void)?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "channel": channel, "ts": timestamp]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(timestamp)
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func setInfo(
        _ endpoint: Endpoint,
        type: InfoType,
        channel: String,
        text: String,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "channel": channel, type.rawValue: text]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func create(
        _ endpoint: Endpoint,
        name: String,
        success: ChannelClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "name": name]
        networkInterface.request(endpoint, parameters: parameters, successClosure: {(response) in
            success?(Channel(channel: response["channel"] as? [String: Any]))
        }) {(error) in
            failure?(error)
        }
    }

    fileprivate func invite(
        _ endpoint: Endpoint,
        channel: String,
        user: String,
        success: SuccessClosure?,
        failure: FailureClosure?
    ) {
        let parameters: [String: Any] = ["token": token, "channel": channel, "user": user]
        networkInterface.request(endpoint, parameters: parameters, successClosure: { _ in
            success?(true)
        }) {(error) in
            failure?(error)
        }
    }
}
