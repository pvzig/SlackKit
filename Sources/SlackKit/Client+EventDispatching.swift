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

internal extension SlackClient {
    
    func dispatch(_ anEvent: [String: Any]) {
        let event = Event(anEvent)
        let type = event.type ?? .unknown
        switch type {
        case .hello:
            connected = true
            pingRTMServer()
            connectionEventsDelegate?.connected(self)
        case .ok:
            messageSent(event)
        case .message:
            if (event.subtype != nil) {
                messageDispatcher(event)
            } else {
                messageReceived(event)
            }
        case .userTyping:
            userTyping(event)
        case .channelMarked, .imMarked, .groupMarked:
            channelMarked(event)
        case .channelCreated, .imCreated:
            channelCreated(event)
        case .channelJoined, .groupJoined:
            channelJoined(event)
        case .channelLeft, .groupLeft:
            channelLeft(event)
        case .channelDeleted:
            channelDeleted(event)
        case .channelRenamed, .groupRename:
            channelRenamed(event)
        case .channelArchive, .groupArchive:
            channelArchived(event, archived: true)
        case .channelUnarchive, .groupUnarchive:
            channelArchived(event, archived: false)
        case .channelHistoryChanged, .imHistoryChanged, .groupHistoryChanged:
            channelHistoryChanged(event)
        case .dndUpdated:
            doNotDisturbUpdated(event)
        case .dndUpatedUser:
            doNotDisturbUserUpdated(event)
        case .imOpen, .groupOpen:
            open(event, open: true)
        case .imClose, .groupClose:
            open(event, open: false)
        case .fileCreated:
            processFile(event)
        case .fileShared:
            processFile(event)
        case .fileUnshared:
            processFile(event)
        case .filePublic:
            processFile(event)
        case .filePrivate:
            filePrivate(event)
        case .fileChanged:
            processFile(event)
        case .fileDeleted:
            deleteFile(event)
        case .fileCommentAdded:
            fileCommentAdded(event)
        case .fileCommentEdited:
            fileCommentEdited(event)
        case .fileCommentDeleted:
            fileCommentDeleted(event)
        case .pinAdded:
            pinAdded(event)
        case .pinRemoved:
            pinRemoved(event)
        case .pong:
            pong(event)
        case .presenceChange:
            presenceChange(event)
        case .manualPresenceChange:
            manualPresenceChange(event)
        case .prefChange:
            changePreference(event)
        case .userChange:
            userChange(event)
        case .teamJoin:
            teamJoin(event)
        case .starAdded:
            itemStarred(event, star: true)
        case .starRemoved:
            itemStarred(event, star: false)
        case .reactionAdded:
            addedReaction(event)
        case .reactionRemoved:
            removedReaction(event)
        case .emojiChanged:
            emojiChanged(event)
        case .commandsChanged:
            // This functionality is only used by our web client.
            // The other APIs required to support slash command metadata are currently unstable.
            // Until they are released other clients should ignore this event.
            break
        case .teamPlanChange:
            teamPlanChange(event)
        case .teamPrefChange:
            teamPreferenceChange(event)
        case .teamRename:
            teamNameChange(event)
        case .teamDomainChange:
            teamDomainChange(event)
        case .emailDomainChange:
            emailDomainChange(event)
        case .teamProfileChange:
            teamProfileChange(event)
        case .teamProfileDelete:
            teamProfileDeleted(event)
        case .teamProfileReorder:
            teamProfileReordered(event)
        case .botAdded:
            bot(event)
        case .botChanged:
            bot(event)
        case .accountsChanged:
            // The accounts_changed event is used by our web client to maintain a list of logged-in accounts.
            // Other clients should ignore this event.
            break
        case .teamMigrationStarted:
            connect(pingInterval: pingInterval, timeout: timeout, reconnect: reconnect)
        case .reconnectURL:
            // The reconnect_url event is currently unsupported and experimental.
            break
        case .subteamCreated, .subteamUpdated:
            subteam(event)
        case .subteamSelfAdded:
            subteamAddedSelf(event)
        case .subteamSelfRemoved:
            subteamRemovedSelf(event)
        case .error:
            print("Error: \(anEvent)")
        case .unknown:
            print("Unsupported event of type: \(anEvent["type"] ?? "No Type Information")")
        }
    }
    
    func messageDispatcher(_ event:Event) {
        guard let value = event.subtype, let subtype = MessageSubtype(rawValue:value) else {
            return
        }
        switch subtype {
        case .messageChanged:
            messageChanged(event)
        case .messageDeleted:
            messageDeleted(event)
        default:
            messageReceived(event)
        }
    }
}
