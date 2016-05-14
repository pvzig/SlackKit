//
// EventDelegate.swift
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

public protocol SlackEventsDelegate: class {
    func clientConnectionFailed(error: SlackError)
    func clientConnected()
    func clientDisconnected()
    func preferenceChanged(preference: String, value: AnyObject)
    func userChanged(user: User)
    func presenceChanged(user: User?, presence: String?)
    func manualPresenceChanged(user: User?, presence: String?)
    func botEvent(bot: Bot)
}

public protocol MessageEventsDelegate: class {
    func messageSent(message: Message)
    func messageReceived(message: Message)
    func messageChanged(message: Message)
    func messageDeleted(message: Message?)
}

public protocol ChannelEventsDelegate: class {
    func userTyping(channel: Channel?, user: User?)
    func channelMarked(channel: Channel, timestamp: String?)
    func channelCreated(channel: Channel)
    func channelDeleted(channel: Channel)
    func channelRenamed(channel: Channel)
    func channelArchived(channel: Channel)
    func channelHistoryChanged(channel: Channel)
    func channelJoined(channel: Channel)
    func channelLeft(channel: Channel)
}

public protocol DoNotDisturbEventsDelegate: class {
    func doNotDisturbUpdated(dndStatus: DoNotDisturbStatus)
    func doNotDisturbUserUpdated(dndStatus: DoNotDisturbStatus, user: User?)
}

public protocol GroupEventsDelegate: class {
    func groupOpened(group: Channel)
}

public protocol FileEventsDelegate: class {
    func fileProcessed(file: File)
    func fileMadePrivate(file: File)
    func fileDeleted(file: File)
    func fileCommentAdded(file: File, comment: Comment)
    func fileCommentEdited(file: File, comment: Comment)
    func fileCommentDeleted(file: File, comment: Comment)
}

public protocol PinEventsDelegate: class {
    func itemPinned(item: Item?, channel: Channel?)
    func itemUnpinned(item: Item?, channel: Channel?)
}

public protocol StarEventsDelegate: class {
    func itemStarred(item: Item, star: Bool)
}

public protocol ReactionEventsDelegate: class {
    func reactionAdded(reaction: String?, item: Item?, itemUser: String?)
    func reactionRemoved(reaction: String?, item: Item?, itemUser: String?)
}

public protocol TeamEventsDelegate: class {
    func teamJoined(user: User)
    func teamPlanChanged(plan: String)
    func teamPreferencesChanged(preference: String, value: AnyObject)
    func teamNameChanged(name: String)
    func teamDomainChanged(domain: String)
    func teamEmailDomainChanged(domain: String)
    func teamEmojiChanged()
}

public protocol SubteamEventsDelegate: class {
    func subteamEvent(userGroup: UserGroup)
    func subteamSelfAdded(subteamID: String)
    func subteamSelfRemoved(subteamID: String)
}

public protocol TeamProfileEventsDelegate: class {
    func teamProfileChanged(profile: CustomProfile?)
    func teamProfileDeleted(profile: CustomProfile?)
    func teamProfileReordered(profile: CustomProfile?)
}
