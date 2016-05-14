//
// Client+EventDispatching.swift
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

internal extension Client {

    func dispatch(event: [String: AnyObject]) {
        let event = Event(event: event)
        if let type = event.type {
            switch type {
            case .Hello:
                connected = true
                slackEventsDelegate?.clientConnected()
            case .Ok:
                messageSent(event)
            case .Message:
                if (event.subtype != nil) {
                    messageDispatcher(event)
                } else {
                    messageReceived(event)
                }
            case .UserTyping:
                userTyping(event)
            case .ChannelMarked, .IMMarked, .GroupMarked:
                channelMarked(event)
            case .ChannelCreated, .IMCreated:
                channelCreated(event)
            case .ChannelJoined, .GroupJoined:
                channelJoined(event)
            case .ChannelLeft, .GroupLeft:
                channelLeft(event)
            case .ChannelDeleted:
                channelDeleted(event)
            case .ChannelRenamed, .GroupRename:
                channelRenamed(event)
            case .ChannelArchive, .GroupArchive:
                channelArchived(event, archived: true)
            case .ChannelUnarchive, .GroupUnarchive:
                channelArchived(event, archived: false)
            case .ChannelHistoryChanged, .IMHistoryChanged, .GroupHistoryChanged:
                channelHistoryChanged(event)
            case .DNDUpdated:
                doNotDisturbUpdated(event)
            case .DNDUpatedUser:
                doNotDisturbUserUpdated(event)
            case .IMOpen, .GroupOpen:
                open(event, open: true)
            case .IMClose, .GroupClose:
                open(event, open: false)
            case .FileCreated:
                processFile(event)
            case .FileShared:
                processFile(event)
            case .FileUnshared:
                processFile(event)
            case .FilePublic:
                processFile(event)
            case .FilePrivate:
                filePrivate(event)
            case .FileChanged:
                processFile(event)
            case .FileDeleted:
                deleteFile(event)
            case .FileCommentAdded:
                fileCommentAdded(event)
            case .FileCommentEdited:
                fileCommentEdited(event)
            case .FileCommentDeleted:
                fileCommentDeleted(event)
            case .PinAdded:
                pinAdded(event)
            case .PinRemoved:
                pinRemoved(event)
            case .Pong:
                pong(event)
            case .PresenceChange:
                presenceChange(event)
            case .ManualPresenceChange:
                manualPresenceChange(event)
            case .PrefChange:
                changePreference(event)
            case .UserChange:
                userChange(event)
            case .TeamJoin:
                teamJoin(event)
            case .StarAdded:
                itemStarred(event, star: true)
            case .StarRemoved:
                itemStarred(event, star: false)
            case .ReactionAdded:
                addedReaction(event)
            case .ReactionRemoved:
                removedReaction(event)
            case .EmojiChanged:
                emojiChanged(event)
            case .CommandsChanged:
                // This functionality is only used by our web client. 
                // The other APIs required to support slash command metadata are currently unstable. 
                // Until they are released other clients should ignore this event.
                break
            case .TeamPlanChange:
                teamPlanChange(event)
            case .TeamPrefChange:
                teamPreferenceChange(event)
            case .TeamRename:
                teamNameChange(event)
            case .TeamDomainChange:
                teamDomainChange(event)
            case .EmailDomainChange:
                emailDomainChange(event)
            case .TeamProfileChange:
                teamProfileChange(event)
            case .TeamProfileDelete:
                teamProfileDeleted(event)
            case .TeamProfileReorder:
                teamProfileReordered(event)
            case .BotAdded:
                bot(event)
            case .BotChanged:
                bot(event)
            case .AccountsChanged:
                // The accounts_changed event is used by our web client to maintain a list of logged-in accounts.
                // Other clients should ignore this event.
                break
            case .TeamMigrationStarted:
                connect(pingInterval: pingInterval, timeout: timeout, reconnect: reconnect)
            case .ReconnectURL:
                // The reconnect_url event is currently unsupported and experimental.
                break
            case .SubteamCreated, .SubteamUpdated:
                subteam(event)
            case .SubteamSelfAdded:
                subteamAddedSelf(event)
            case.SubteamSelfRemoved:
                subteamRemovedSelf(event)
            case .Error:
                print("Error: \(event)")
                break
            }
        }
    }
    
    func messageDispatcher(event:Event) {
        let subtype = MessageSubtype(rawValue: event.subtype!)!
        switch subtype {
        case .MessageChanged:
            messageChanged(event)
        case .MessageDeleted:
            messageDeleted(event)
        default:
            messageReceived(event)
        }
    }
    
}
