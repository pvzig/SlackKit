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

public protocol ConnectionEventsDelegate: class {
    func clientConnected(_ client: Client)
    func clientDisconnected(_ client: Client)
    func clientConnectionFailed(_ client: Client, error: SlackError)
}

public protocol MessageEventsDelegate: class {
    func messageSent(_ client: Client, message: Message)
    func messageReceived(_ client: Client, message: Message)
    func messageChanged(_ client: Client, message: Message)
    func messageDeleted(_ client: Client, message: Message?)
}

public protocol ChannelEventsDelegate: class {
    func userTyping(_ client: Client, channel: Channel, user: User)
    func channelMarked(_ client: Client, channel: Channel, timestamp: String)
    func channelCreated(_ client: Client, channel: Channel)
    func channelDeleted(_ client: Client, channel: Channel)
    func channelRenamed(_ client: Client, channel: Channel)
    func channelArchived(_ client: Client, channel: Channel)
    func channelHistoryChanged(_ client: Client, channel: Channel)
    func channelJoined(_ client: Client, channel: Channel)
    func channelLeft(_ client: Client, channel: Channel)
}

public protocol DoNotDisturbEventsDelegate: class {
    func doNotDisturbUpdated(_ client: Client, dndStatus: DoNotDisturbStatus)
    func doNotDisturbUserUpdated(_ client: Client, dndStatus: DoNotDisturbStatus, user: User)
}

public protocol GroupEventsDelegate: class {
    func groupOpened(_ client: Client, group: Channel)
}

public protocol FileEventsDelegate: class {
    func fileProcessed(_ client: Client, file: File)
    func fileMadePrivate(_ client: Client, file: File)
    func fileDeleted(_ client: Client, file: File)
    func fileCommentAdded(_ client: Client, file: File, comment: Comment)
    func fileCommentEdited(_ client: Client, file: File, comment: Comment)
    func fileCommentDeleted(_ client: Client, file: File, comment: Comment)
}

public protocol PinEventsDelegate: class {
    func itemPinned(_ client: Client, item: Item, channel: Channel?)
    func itemUnpinned(_ client: Client, item: Item, channel: Channel?)
}

public protocol StarEventsDelegate: class {
    func itemStarred(_ client: Client, item: Item, star: Bool)
}

public protocol ReactionEventsDelegate: class {
    func reactionAdded(_ client: Client, reaction: String, item: Item, itemUser: String)
    func reactionRemoved(_ client: Client, reaction: String, item: Item, itemUser: String)
}

public protocol SlackEventsDelegate: class {
    func preferenceChanged(_ client: Client, preference: String, value: Any?)
    func userChanged(_ client: Client, user: User)
    func presenceChanged(_ client: Client, user: User, presence: String)
    func manualPresenceChanged(_ client: Client, user: User, presence: String)
    func botEvent(_ client: Client, bot: Bot)
}

public protocol TeamEventsDelegate: class {
    func teamJoined(_ client: Client, user: User)
    func teamPlanChanged(_ client: Client, plan: String)
    func teamPreferencesChanged(_ client: Client, preference: String, value: Any?)
    func teamNameChanged(_ client: Client, name: String)
    func teamDomainChanged(_ client: Client, domain: String)
    func teamEmailDomainChanged(_ client: Client, domain: String)
    func teamEmojiChanged(_ client: Client)
}

public protocol SubteamEventsDelegate: class {
    func subteamEvent(_ client: Client, userGroup: UserGroup)
    func subteamSelfAdded(_ client: Client, subteamID: String)
    func subteamSelfRemoved(_ client: Client, subteamID: String)
}

public protocol TeamProfileEventsDelegate: class {
    func teamProfileChanged(_ client: Client, profile: CustomProfile)
    func teamProfileDeleted(_ client: Client, profile: CustomProfile)
    func teamProfileReordered(_ client: Client, profile: CustomProfile)
}
