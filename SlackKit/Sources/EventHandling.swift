//
// EventHandling.swift
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

internal extension Client {

    //MARK: - Pong
    func pong(event: Event) {
        pong = event.replyTo
    }
    
    //MARK: - Messages
    func messageSent(event: Event) {
        if let reply = event.replyTo, message = sentMessages[NSNumber(double: reply).stringValue], channel = message.channel, ts = message.ts {
            message.ts = event.ts
            message.text = event.text
            channels[channel]?.messages[ts] = message
            
            messageEventsDelegate?.messageSent(message)
        }
    }
    
    func messageReceived(event: Event) {
        if let channel = event.channel, message = event.message, id = channel.id, ts = message.ts {
            channels[id]?.messages[ts] = message
            
            messageEventsDelegate?.messageReceived(message)
        }
    }
    
    func messageChanged(event: Event) {
        if let id = event.channel?.id, nested = event.nestedMessage, ts = nested.ts {
            channels[id]?.messages[ts] = nested
            
            messageEventsDelegate?.messageChanged(nested)
        }
    }
    
    func messageDeleted(event: Event) {
        if let id = event.channel?.id, key = event.message?.deletedTs {
            let message = channels[id]?.messages[key]
            channels[id]?.messages.removeValueForKey(key)
            
            messageEventsDelegate?.messageDeleted(message)
        }
    }
    
    //MARK: - Channels
    func userTyping(event: Event) {
        if let channelID = event.channel?.id, userID = event.user?.id {
            if let _ = channels[channelID] {
                if (!channels[channelID]!.usersTyping.contains(userID)) {
                    channels[channelID]?.usersTyping.append(userID)
                    
                    channelEventsDelegate?.userTyping(event.channel, user: event.user)
                }
            }
            
            let timeout = dispatch_time(DISPATCH_TIME_NOW, Int64(5.0 * Double(NSEC_PER_SEC)))
            dispatch_after(timeout, dispatch_get_main_queue()) {
                if let index = self.channels[channelID]?.usersTyping.indexOf(userID) {
                    self.channels[channelID]?.usersTyping.removeAtIndex(index)
                }
            }
        }
    }
    
    func channelMarked(event: Event) {
        if let channel = event.channel, id = channel.id {
            channels[id]?.lastRead = event.ts
            
            channelEventsDelegate?.channelMarked(channel, timestamp: event.ts)
        }
        //TODO: Recalculate unreads
    }
    
    func channelCreated(event: Event) {
        if let channel = event.channel, id = channel.id {
            channels[id] = channel
            
            channelEventsDelegate?.channelCreated(channel)
        }
    }
    
    func channelDeleted(event: Event) {
        if let channel = event.channel, id = channel.id {
            channels.removeValueForKey(id)
            
            channelEventsDelegate?.channelDeleted(channel)
        }
    }
    
    func channelJoined(event: Event) {
        if let channel = event.channel, id = channel.id {
            channels[id] = event.channel
            
            channelEventsDelegate?.channelJoined(channel)
        }
    }
    
    func channelLeft(event: Event) {
        if let channel = event.channel, id = channel.id, userID = authenticatedUser?.id {
            if let index = channels[id]?.members?.indexOf(userID) {
                channels[id]?.members?.removeAtIndex(index)
                
                channelEventsDelegate?.channelLeft(channel)
            }
        }
    }
    
    func channelRenamed(event: Event) {
        if let channel = event.channel, id = channel.id {
            channels[id]?.name = channel.name
            
            channelEventsDelegate?.channelRenamed(channel)
        }
    }
    
    func channelArchived(event: Event, archived: Bool) {
        if let channel = event.channel, id = channel.id {
            channels[id]?.isArchived = archived
            
            channelEventsDelegate?.channelArchived(channel)
        }
    }
    
    func channelHistoryChanged(event: Event) {
        if let channel = event.channel {
            //TODO: Reload chat history if there are any cached messages before latest
            
            channelEventsDelegate?.channelHistoryChanged(channel)
        }
    }
    
    //MARK: - Do Not Disturb
    func doNotDisturbUpdated(event: Event) {
        if let dndStatus = event.dndStatus {
            authenticatedUser?.doNotDisturbStatus = dndStatus
            
            doNotDisturbEventsDelegate?.doNotDisturbUpdated(dndStatus)
        }
    }
    
    func doNotDisturbUserUpdated(event: Event) {
        if let dndStatus = event.dndStatus, user = event.user, id = user.id {
            users[id]?.doNotDisturbStatus = dndStatus
            
            doNotDisturbEventsDelegate?.doNotDisturbUserUpdated(dndStatus, user: user)
        }
    }
    
    //MARK: - IM & Group Open/Close
    func open(event: Event, open: Bool) {
        if let channel = event.channel, id = channel.id {
            channels[id]?.isOpen = open
            
            groupEventsDelegate?.groupOpened(channel)
        }
    }
    
    //MARK: - Files
    func processFile(event: Event) {
        if let file = event.file, id = file.id {
            if let comment = file.initialComment, commentID = comment.id {
                if files[id]?.comments[commentID] == nil {
                    files[id]?.comments[commentID] = comment
                }
            }
            
            files[id] = file
            
            fileEventsDelegate?.fileProcessed(file)
        }
    }
    
    func filePrivate(event: Event) {
        if let file =  event.file, id = file.id {
            files[id]?.isPublic = false
            
            fileEventsDelegate?.fileMadePrivate(file)
        }
    }
    
    func deleteFile(event: Event) {
        if let file = event.file, id = file.id {
            if files[id] != nil {
                files.removeValueForKey(id)
            }
            
            fileEventsDelegate?.fileDeleted(file)
        }
    }
    
    func fileCommentAdded(event: Event) {
        if let file = event.file, id = file.id, comment = event.comment, commentID = comment.id {
            files[id]?.comments[commentID] = comment
            
            fileEventsDelegate?.fileCommentAdded(file, comment: comment)
        }
    }
    
    func fileCommentEdited(event: Event) {
        if let file = event.file, id = file.id, comment = event.comment, commentID = comment.id {
            files[id]?.comments[commentID]?.comment = comment.comment
            
            fileEventsDelegate?.fileCommentEdited(file, comment: comment)
        }
    }
    
    func fileCommentDeleted(event: Event) {
        if let file = event.file, id = file.id, comment = event.comment, commentID = comment.id {
            files[id]?.comments.removeValueForKey(commentID)
            
            fileEventsDelegate?.fileCommentDeleted(file, comment: comment)
        }
    }
    
    //MARK: - Pins
    func pinAdded(event: Event) {
        if let id = event.channelID, item = event.item {
            channels[id]?.pinnedItems.append(item)
            
            pinEventsDelegate?.itemPinned(item, channel: channels[id])
        }
    }
    
    func pinRemoved(event: Event) {
        if let id = event.channelID {
            if let pins = channels[id]?.pinnedItems.filter({$0 != event.item}) {
                channels[id]?.pinnedItems = pins
            }
            
            pinEventsDelegate?.itemUnpinned(event.item, channel: channels[id])
        }
    }
    
    //MARK: - Stars
    func itemStarred(event: Event, star: Bool) {
        if let item = event.item, type = item.type {
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
            
            starEventsDelegate?.itemStarred(item, star: star)
        }
    }
    
    func starMessage(item: Item, star: Bool) {
        if let message = item.message, ts = message.ts, channel = item.channel {
            if let _ = channels[channel]?.messages[ts] {
                channels[channel]?.messages[ts]?.isStarred = star
            }
        }
    }
    
    func starFile(item: Item, star: Bool) {
        if let file = item.file, id = file.id {
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
    }
    
    func starComment(item: Item) {
        if let file = item.file, id = file.id, comment = item.comment, commentID = comment.id {
            files[id]?.comments[commentID] = comment
        }
    }
    
    //MARK: - Reactions
    func addedReaction(event: Event) {
        if let item = event.item, type = item.type, key = event.reaction, userID = event.user?.id {
            switch type {
            case "message":
                if let channel = item.channel, ts = item.ts {
                    if let message = channels[channel]?.messages[ts] {
                        if (message.reactions[key]) == nil {
                            message.reactions[key] = Reaction(name: event.reaction, user: userID)
                        } else {
                            message.reactions[key]?.users[userID] = userID
                        }
                    }
                }
            case "file":
                if let id = item.file?.id, file = files[id] {
                    if file.reactions[key] == nil {
                        files[id]?.reactions[key] = Reaction(name: event.reaction, user: userID)
                    } else {
                        files[id]?.reactions[key]?.users[userID] = userID
                    }
                }
            case "file_comment":
                if let id = item.file?.id, file = files[id], commentID = item.fileCommentID {
                    if file.comments[commentID]?.reactions[key] == nil {
                        files[id]?.comments[commentID]?.reactions[key] = Reaction(name: event.reaction, user: userID)
                    } else {
                        files[id]?.comments[commentID]?.reactions[key]?.users[userID] = userID
                    }
                }
                break
            default:
                break
            }
            
            reactionEventsDelegate?.reactionAdded(event.reaction, item: event.item, itemUser: event.itemUser)
        }
    }
    
    func removedReaction(event: Event) {
        if let item = event.item, type = item.type, key = event.reaction, userID = event.user?.id {
            switch type {
            case "message":
                if let channel = item.channel, ts = item.ts {
                    if let message = channels[channel]?.messages[ts] {
                        if (message.reactions[key]) != nil {
                            message.reactions[key]?.users.removeValueForKey(userID)
                        }
                        if (message.reactions[key]?.users.count == 0) {
                            message.reactions.removeValueForKey(key)
                        }
                    }
                }
            case "file":
                if let itemFile = item.file, id = itemFile.id, file = files[id] {
                    if file.reactions[key] != nil {
                        files[id]?.reactions[key]?.users.removeValueForKey(userID)
                    }
                    if files[id]?.reactions[key]?.users.count == 0 {
                        files[id]?.reactions.removeValueForKey(key)
                    }
                }
            case "file_comment":
                if let id = item.file?.id, file = files[id], commentID = item.fileCommentID {
                    if file.comments[commentID]?.reactions[key] != nil {
                        files[id]?.comments[commentID]?.reactions[key]?.users.removeValueForKey(userID)
                    }
                    if files[id]?.comments[commentID]?.reactions[key]?.users.count == 0 {
                        files[id]?.comments[commentID]?.reactions.removeValueForKey(key)
                    }
                }
                break
            default:
                break
            }
            
            reactionEventsDelegate?.reactionAdded(event.reaction, item: event.item, itemUser: event.itemUser)
        }
    }
    
    //MARK: - Preferences
    func changePreference(event: Event) {
        if let name = event.name {
            authenticatedUser?.preferences?[name] = event.value
            
            if let value = event.value {
                slackEventsDelegate?.preferenceChanged(name, value: value)
            }
        }
    }
    
    //Mark: - User Change
    func userChange(event: Event) {
        if let user = event.user, id = user.id {
            let preferences = users[id]?.preferences
            users[id] = user
            users[id]?.preferences = preferences
            
            slackEventsDelegate?.userChanged(user)
        }
    }
    
    //MARK: - User Presence
    func presenceChange(event: Event) {
        if let user = event.user, id = user.id {
            users[id]?.presence = event.presence
            
            slackEventsDelegate?.presenceChanged(user, presence: event.presence)
        }
    }
    
    //MARK: - Team
    func teamJoin(event: Event) {
        if let user = event.user, id = user.id {
            users[id] = user
            
            teamEventsDelegate?.teamJoined(user)
        }
    }
    
    func teamPlanChange(event: Event) {
        if let plan = event.plan {
            team?.plan = plan
            
            teamEventsDelegate?.teamPlanChanged(plan)
        }
    }
    
    func teamPreferenceChange(event: Event) {
        if let name = event.name {
            team?.prefs?[name] = event.value
            
            if let value = event.value {
                teamEventsDelegate?.teamPreferencesChanged(name, value: value)
            }
        }
    }
    
    func teamNameChange(event: Event) {
        if let name = event.name {
            team?.name = name
            
            teamEventsDelegate?.teamNameChanged(name)
        }
    }
    
    func teamDomainChange(event: Event) {
        if let domain = event.domain {
            team?.domain = domain
            
            teamEventsDelegate?.teamDomainChanged(domain)
        }
    }
    
    func emailDomainChange(event: Event) {
        if let domain = event.emailDomain {
            team?.emailDomain = domain
            
            teamEventsDelegate?.teamEmailDomainChanged(domain)
        }
    }
    
    func emojiChanged(event: Event) {
        //TODO: Call emoji.list here
        
        teamEventsDelegate?.teamEmojiChanged()
    }
    
    //MARK: - Bots
    func bot(event: Event) {
        if let bot = event.bot, id = bot.id {
            bots[id] = bot
            
            slackEventsDelegate?.botEvent(bot)
        }
    }
    
    //MARK: - Subteams
    func subteam(event: Event) {
        if let subteam = event.subteam, id = subteam.id {
            userGroups[id] = subteam
            
            subteamEventsDelegate?.subteamEvent(subteam)
        }
        
    }
    
    func subteamAddedSelf(event: Event) {
        if let subteamID = event.subteamID, _ = authenticatedUser?.userGroups {
            authenticatedUser?.userGroups![subteamID] = subteamID
            
            subteamEventsDelegate?.subteamSelfAdded(subteamID)
        }
    }
    
    func subteamRemovedSelf(event: Event) {
        if let subteamID = event.subteamID {
            authenticatedUser?.userGroups?.removeValueForKey(subteamID)
            
            subteamEventsDelegate?.subteamSelfRemoved(subteamID)
        }
    }
    
    //MARK: - Team Profiles
    func teamProfileChange(event: Event) {
        for user in users {
            if let fields = event.profile?.fields {
                for key in fields.keys {
                    users[user.0]?.profile?.customProfile?.fields[key]?.updateProfileField(fields[key])
                }
            }
        }
        
        teamProfileEventsDelegate?.teamProfileChanged(event.profile)
    }
    
    func teamProfileDeleted(event: Event) {
        for user in users {
            if let id = event.profile?.fields.first?.0 {
                users[user.0]?.profile?.customProfile?.fields[id] = nil
            }
        }
        
        teamProfileEventsDelegate?.teamProfileDeleted(event.profile)
    }
    
    func teamProfileReordered(event: Event) {
        for user in users {
            if let keys = event.profile?.fields.keys {
                for key in keys {
                    users[user.0]?.profile?.customProfile?.fields[key]?.ordering = event.profile?.fields[key]?.ordering
                }
            }
        }
        
        teamProfileEventsDelegate?.teamProfileReordered(event.profile)
    }
    
    //MARK: - Authenticated User
    func manualPresenceChange(event: Event) {
        authenticatedUser?.presence = event.presence
        
        slackEventsDelegate?.manualPresenceChanged(authenticatedUser, presence: event.presence)
    }
    
}
