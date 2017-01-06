//
// Client+EventHandling.swift
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
import Dispatch

internal extension SlackClient {
    
    //MARK: - Pong
    func pong(_ event: Event) {
        pong = event.replyTo
    }
    
    //MARK: - Messages
    func messageSent(_ event: Event) {
        guard let reply = event.replyTo, let message = sentMessages[NSNumber(value: reply).stringValue], let channel = message.channel, let ts = message.ts else {
            return
        }
        
        message.ts = event.ts
        message.text = event.text
        channels[channel]?.messages[ts] = message
        messageEventsDelegate?.sent(message, client: self)
    }
    
    func messageReceived(_ event: Event) {
        guard let channel = event.channel, let message = event.message, let id = channel.id, let ts = message.ts else {
            return
        }
        
        channels[id]?.messages[ts] = message
        messageEventsDelegate?.received(message, client:self)
    }
    
    func messageChanged(_ event: Event) {
        guard let id = event.channel?.id, let nested = event.nestedMessage, let ts = nested.ts else {
            return
        }
        
        channels[id]?.messages[ts] = nested
        messageEventsDelegate?.changed(nested, client:self)
    }
    
    func messageDeleted(_ event: Event) {
        guard let id = event.channel?.id, let key = event.message?.deletedTs, let message = channels[id]?.messages[key] else {
            return
        }
        
        _ = channels[id]?.messages.removeValue(forKey: key)
        messageEventsDelegate?.deleted(message, client:self)
    }
    
    //MARK: - Channels
    func userTyping(_ event: Event) {
        guard let channel = event.channel, let channelID = channel.id, let user = event.user, let userID = user.id ,
            channels.index(forKey: channelID) != nil && !channels[channelID]!.usersTyping.contains(userID) else {
                return
        }
        
        channels[channelID]?.usersTyping.append(userID)
        channelEventsDelegate?.userTypingIn(channel, user: user, client: self)
        
        let timeout = DispatchTime.now() + Double(Int64(5.0 * Double(CLOCKS_PER_SEC))) / Double(CLOCKS_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: timeout, execute: {
            if let index = self.channels[channelID]?.usersTyping.index(of: userID) {
                self.channels[channelID]?.usersTyping.remove(at: index)
            }
        })
    }
    
    func channelMarked(_ event: Event) {
        guard let channel = event.channel, let id = channel.id, let timestamp = event.ts else {
            return
        }
        
        channels[id]?.lastRead = event.ts
        channelEventsDelegate?.marked(channel, timestamp: timestamp, client: self)
    }
    
    func channelCreated(_ event: Event) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels[id] = channel
        channelEventsDelegate?.created(channel, client: self)
    }
    
    func channelDeleted(_ event: Event) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels.removeValue(forKey: id)
        channelEventsDelegate?.deleted(channel, client: self)
    }
    
    func channelJoined(_ event: Event) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels[id] = event.channel
        channelEventsDelegate?.joined(channel, client: self)
    }
    
    func channelLeft(_ event: Event) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        if let userID = authenticatedUser?.id, let index = channels[id]?.members?.index(of: userID) {
            channels[id]?.members?.remove(at: index)
        }
        channelEventsDelegate?.left(channel, client: self)
    }
    
    func channelRenamed(_ event: Event) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels[id]?.name = channel.name
        channelEventsDelegate?.renamed(channel, client: self)
    }
    
    func channelArchived(_ event: Event, archived: Bool) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels[id]?.isArchived = archived
        channelEventsDelegate?.archived(channel, client: self)
    }
    
    func channelHistoryChanged(_ event: Event) {
        guard let channel = event.channel else {
            return
        }
        channelEventsDelegate?.historyChanged(channel, client: self)
    }
    
    //MARK: - Do Not Disturb
    func doNotDisturbUpdated(_ event: Event) {
        guard let dndStatus = event.dndStatus else {
            return
        }
        
        authenticatedUser?.doNotDisturbStatus = dndStatus
        doNotDisturbEventsDelegate?.updated(dndStatus, client: self)
    }
    
    func doNotDisturbUserUpdated(_ event: Event) {
        guard let dndStatus = event.dndStatus, let user = event.user, let id = user.id else {
            return
        }
        
        users[id]?.doNotDisturbStatus = dndStatus
        doNotDisturbEventsDelegate?.userUpdated(dndStatus, user: user, client: self)
    }
    
    //MARK: - IM & Group Open/Close
    func open(_ event: Event, open: Bool) {
        guard let channel = event.channel, let id = channel.id else {
            return
        }
        
        channels[id]?.isOpen = open
        groupEventsDelegate?.opened(channel, client: self)
    }
    
    //MARK: - Files
    func processFile(_ event: Event) {
        guard let file = event.file, let id = file.id else {
            return
        }
        if let comment = file.initialComment, let commentID = comment.id {
            if files[id]?.comments[commentID] == nil {
                files[id]?.comments[commentID] = comment
            }
        }
        
        files[id] = file
        fileEventsDelegate?.processed(file, client: self)
    }
    
    func filePrivate(_ event: Event) {
        guard let file =  event.file, let id = file.id else {
            return
        }
        
        files[id]?.isPublic = false
        fileEventsDelegate?.madePrivate(file, client: self)
    }
    
    func deleteFile(_ event: Event) {
        guard let file = event.file, let id = file.id else {
            return
        }
        
        if files[id] != nil {
            files.removeValue(forKey: id)
        }
        fileEventsDelegate?.deleted(file, client: self)
    }
    
    func fileCommentAdded(_ event: Event) {
        guard let file = event.file, let id = file.id, let comment = event.comment, let commentID = comment.id else {
            return
        }
        
        files[id]?.comments[commentID] = comment
        fileEventsDelegate?.commentAdded(file, comment: comment, client: self)
    }
    
    func fileCommentEdited(_ event: Event) {
        guard let file = event.file, let id = file.id, let comment = event.comment, let commentID = comment.id else {
            return
        }
        
        files[id]?.comments[commentID]?.comment = comment.comment
        fileEventsDelegate?.commentAdded(file, comment: comment, client: self)
    }
    
    func fileCommentDeleted(_ event: Event) {
        guard let file = event.file, let id = file.id, let comment = event.comment, let commentID = comment.id else {
            return
        }
        
        _ = files[id]?.comments.removeValue(forKey: commentID)
        fileEventsDelegate?.commentDeleted(file, comment: comment, client: self)
    }
    
    //MARK: - Pins
    func pinAdded(_ event: Event) {
        guard let id = event.channelID, let item = event.item else {
            return
        }
        
        channels[id]?.pinnedItems.append(item)
        pinEventsDelegate?.pinned(item, channel: channels[id], client: self)
    }
    
    func pinRemoved(_ event: Event) {
        guard let id = event.channelID, let item = event.item else {
            return
        }
        
        if let pins = channels[id]?.pinnedItems.filter({$0 != item}) {
            channels[id]?.pinnedItems = pins
        }
        pinEventsDelegate?.unpinned(item, channel: channels[id], client: self)
    }
    
    //MARK: - Stars
    func itemStarred(_ event: Event, star: Bool) {
        guard let item = event.item, let type = item.type else {
            return
        }
        switch type {
        case "message":
            starMessage(item, star: star)
        case "file":
            starFile(item, star: star)
        case "file_comment":
            starComment(item)
        default:
            break
        }
        
        starEventsDelegate?.starred(item, starred: star, self)
    }
    
    func starMessage(_ item: Item, star: Bool) {
        guard let message = item.message, let ts = message.ts, let channel = item.channel , channels[channel]?.messages[ts] != nil else {
            return
        }
        channels[channel]?.messages[ts]?.isStarred = star
    }
    
    func starFile(_ item: Item, star: Bool) {
        guard let file = item.file, let id = file.id else {
            return
        }
        
        files[id]?.isStarred = star
        if let stars = files[id]?.stars {
            if star == true {
                files[id]?.stars = stars + 1
            } else {
                if stars > 0 {
                    files[id]?.stars = stars - 1
                }
            }
        }
    }
    
    func starComment(_ item: Item) {
        guard let file = item.file, let id = file.id, let comment = item.comment, let commentID = comment.id else {
            return
        }
        files[id]?.comments[commentID] = comment
    }
    
    //MARK: - Reactions
    func addedReaction(_ event: Event) {
        guard let item = event.item, let type = item.type, let reaction = event.reaction, let userID = event.user?.id, let itemUser = event.itemUser else {
            return
        }
        
        switch type {
        case "message":
            guard let channel = item.channel, let ts = item.ts, let message = channels[channel]?.messages[ts] else {
                return
            }
            message.reactions.append(Reaction(name: reaction, user: userID))
        case "file":
            guard let id = item.file?.id else {
                return
            }
            files[id]?.reactions.append(Reaction(name: reaction, user: userID))
        case "file_comment":
            guard let id = item.file?.id, let commentID = item.fileCommentID else {
                return
            }
            files[id]?.comments[commentID]?.reactions.append(Reaction(name: reaction, user: userID))
        default:
            break
        }
        
        reactionEventsDelegate?.added(reaction, item: item, itemUser: itemUser, client: self)
    }
    
    func removedReaction(_ event: Event) {
        guard let item = event.item, let type = item.type, let key = event.reaction, let userID = event.user?.id, let itemUser = event.itemUser else {
            return
        }
        
        switch type {
        case "message":
            guard let channel = item.channel, let ts = item.ts, let message = channels[channel]?.messages[ts] else {
                return
            }
            message.reactions = message.reactions.filter({$0.name != key && $0.user != userID})
        case "file":
            guard let itemFile = item.file, let id = itemFile.id else {
                return
            }
            files[id]?.reactions = files[id]!.reactions.filter({$0.name != key && $0.user != userID})
        case "file_comment":
            guard let id = item.file?.id, let commentID = item.fileCommentID else {
                return
            }
            files[id]?.comments[commentID]?.reactions = files[id]!.comments[commentID]!.reactions.filter({$0.name != key && $0.user != userID})
        default:
            break
        }
        
        reactionEventsDelegate?.removed(key, item: item, itemUser: itemUser, client: self)
    }
    
    //MARK: - Preferences
    func changePreference(_ event: Event) {
        guard let name = event.name else {
            return
        }
        
        authenticatedUser?.preferences?[name] = event.value
        slackEventsDelegate?.preferenceChanged(name, value: event.value, client: self)
    }
    
    //Mark: - User Change
    func userChange(_ event: Event) {
        guard let user = event.user, let id = user.id else {
            return
        }
        
        let preferences = users[id]?.preferences
        users[id] = user
        users[id]?.preferences = preferences
        slackEventsDelegate?.userChanged(user, client: self)
    }
    
    //MARK: - User Presence
    func presenceChange(_ event: Event) {
        guard let user = event.user, let id = user.id, let presence = event.presence else {
            return
        }
        
        users[id]?.presence = event.presence
        slackEventsDelegate?.presenceChanged(user, presence: presence, client: self)
    }
    
    //MARK: - Team
    func teamJoin(_ event: Event) {
        guard let user = event.user, let id = user.id else {
            return
        }
        
        users[id] = user
        teamEventsDelegate?.userJoined(user, client: self)
    }
    
    func teamPlanChange(_ event: Event) {
        guard let plan = event.plan else {
            return
        }
        
        team?.plan = plan
        teamEventsDelegate?.planChanged(plan, client: self)
    }
    
    func teamPreferenceChange(_ event: Event) {
        guard let name = event.name else {
            return
        }
        
        team?.prefs?[name] = event.value
        teamEventsDelegate?.preferencesChanged(name, value: event.value, client: self)
    }
    
    func teamNameChange(_ event: Event) {
        guard let name = event.name else {
            return
        }
        
        team?.name = name
        teamEventsDelegate?.nameChanged(name, client: self)
    }
    
    func teamDomainChange(_ event: Event) {
        guard let domain = event.domain else {
            return
        }
        
        team?.domain = domain
        teamEventsDelegate?.domainChanged(domain, client: self)
    }
    
    func emailDomainChange(_ event: Event) {
        guard let domain = event.emailDomain else {
            return
        }
        
        team?.emailDomain = domain
        teamEventsDelegate?.emailDomainChanged(domain, client: self)
    }
    
    func emojiChanged(_ event: Event) {
        teamEventsDelegate?.emojiChanged(self)
    }
    
    //MARK: - Bots
    func bot(_ event: Event) {
        guard let bot = event.bot, let id = bot.id else {
            return
        }
        
        bots[id] = bot
        slackEventsDelegate?.botEvent(bot, client: self)
    }
    
    //MARK: - Subteams
    func subteam(_ event: Event) {
        guard let subteam = event.subteam, let id = subteam.id else {
            return
        }
        
        userGroups[id] = subteam
        subteamEventsDelegate?.event(subteam, client: self)
    }
    
    func subteamAddedSelf(_ event: Event) {
        guard let subteamID = event.subteamID, let _ = authenticatedUser?.userGroups else {
            return
        }
        
        authenticatedUser?.userGroups![subteamID] = subteamID
        subteamEventsDelegate?.selfAdded(subteamID, client: self)
    }
    
    func subteamRemovedSelf(_ event: Event) {
        guard let subteamID = event.subteamID else {
            return
        }
        
        _ = authenticatedUser?.userGroups?.removeValue(forKey: subteamID)
        subteamEventsDelegate?.selfRemoved(subteamID, client: self)
    }
    
    //MARK: - Team Profiles
    func teamProfileChange(_ event: Event) {
        guard let profile = event.profile else {
            return
        }
        
        for user in users {
            for key in profile.fields.keys {
                users[user.0]?.profile?.customProfile?.fields[key]?.updateProfileField(profile.fields[key])
            }
        }
        
        teamProfileEventsDelegate?.changed(profile, client: self)
    }
    
    func teamProfileDeleted(_ event: Event) {
        guard let profile = event.profile else {
            return
        }
        
        for user in users {
            if let id = profile.fields.first?.0 {
                users[user.0]?.profile?.customProfile?.fields[id] = nil
            }
        }
        
        teamProfileEventsDelegate?.deleted(profile, client: self)
    }
    
    func teamProfileReordered(_ event: Event) {
        guard let profile = event.profile else {
            return
        }
        
        for user in users {
            for key in profile.fields.keys {
                users[user.0]?.profile?.customProfile?.fields[key]?.ordering = profile.fields[key]?.ordering
            }
        }
        
        teamProfileEventsDelegate?.reordered(profile, client: self)
    }
    
    //MARK: - Authenticated User
    func manualPresenceChange(_ event: Event) {
        guard let presence = event.presence, let user = authenticatedUser else {
            return
        }
        
        authenticatedUser?.presence = presence
        slackEventsDelegate?.manualPresenceChanged(user, presence: presence, client: self)
    }
}
