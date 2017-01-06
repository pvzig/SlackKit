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
    func connected(_ client: SlackClient)
    func disconnected(_ client: SlackClient)
    func connectionFailed(_ client: SlackClient, error: SlackError)
}

public protocol MessageEventsDelegate: class {
    func sent(_ message: Message, client: SlackClient)
    func received(_ message: Message, client: SlackClient)
    func changed(_ message: Message, client: SlackClient)
    func deleted(_ message: Message?, client: SlackClient)
}

public protocol ChannelEventsDelegate: class {
    func userTypingIn(_ channel: Channel, user: User, client: SlackClient)
    func marked(_ channel: Channel, timestamp: String, client: SlackClient)
    func created(_ channel: Channel, client: SlackClient)
    func deleted(_ channel: Channel, client: SlackClient)
    func renamed(_ channel: Channel, client: SlackClient)
    func archived(_ channel: Channel, client: SlackClient)
    func historyChanged(_ channel: Channel, client: SlackClient)
    func joined(_ channel: Channel, client: SlackClient)
    func left(_ channel: Channel, client: SlackClient)
}

public protocol DoNotDisturbEventsDelegate: class {
    func updated(_ status: DoNotDisturbStatus, client: SlackClient)
    func userUpdated(_ status: DoNotDisturbStatus, user: User, client: SlackClient)
}

public protocol GroupEventsDelegate: class {
    func opened(_ group: Channel, client: SlackClient)
}

public protocol FileEventsDelegate: class {
    func processed(_ file: File, client: SlackClient)
    func madePrivate(_ file: File, client: SlackClient)
    func deleted(_ file: File, client: SlackClient)
    func commentAdded(_ file: File, comment: Comment, client: SlackClient)
    func commentEdited(_ file: File, comment: Comment, client: SlackClient)
    func commentDeleted(_ file: File, comment: Comment, client: SlackClient)
}

public protocol PinEventsDelegate: class {
    func pinned(_ item: Item, channel: Channel?, client: SlackClient)
    func unpinned(_ item: Item, channel: Channel?, client: SlackClient)
}

public protocol StarEventsDelegate: class {
    func starred(_ item: Item, starred: Bool, _ client: SlackClient)
}

public protocol ReactionEventsDelegate: class {
    func added(_ reaction: String, item: Item, itemUser: String, client: SlackClient)
    func removed(_ reaction: String, item: Item, itemUser: String, client: SlackClient)
}

public protocol SlackEventsDelegate: class {
    func preferenceChanged(_ preference: String, value: Any?, client: SlackClient)
    func userChanged(_ user: User, client: SlackClient)
    func presenceChanged(_ user: User, presence: String, client: SlackClient)
    func manualPresenceChanged(_ user: User, presence: String, client: SlackClient)
    func botEvent(_ bot: Bot, client: SlackClient)
}

public protocol TeamEventsDelegate: class {
    func userJoined(_ user: User, client: SlackClient)
    func planChanged(_ plan: String, client: SlackClient)
    func preferencesChanged(_ preference: String, value: Any?, client: SlackClient)
    func nameChanged(_ name: String, client: SlackClient)
    func domainChanged(_ domain: String, client: SlackClient)
    func emailDomainChanged(_ domain: String, client: SlackClient)
    func emojiChanged(_ client: SlackClient)
}

public protocol SubteamEventsDelegate: class {
    func event(_ userGroup: UserGroup, client: SlackClient)
    func selfAdded(_ subteamID: String, client: SlackClient)
    func selfRemoved(_ subteamID: String, client: SlackClient)
}

public protocol TeamProfileEventsDelegate: class {
    func changed(_ profile: CustomProfile, client: SlackClient)
    func deleted(_ profile: CustomProfile, client: SlackClient)
    func reordered(_ profile: CustomProfile, client: SlackClient)
}
