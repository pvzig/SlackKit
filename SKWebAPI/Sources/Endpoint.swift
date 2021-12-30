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

public enum Endpoint: String {
    case apiTest = "api.test"
    case authRevoke = "auth.revoke"
    case authTest = "auth.test"
    case channelsHistory = "channels.history"
    case channelsKick = "channels.kick"
    case channelsLeave = "channels.leave"
    case channelsRename = "channels.rename"
    case channelsSetPurpose = "channels.setPurpose"
    case channelsSetTopic = "channels.setTopic"
    case channelsUnarchive = "channels.unarchive"
    case chatDelete = "chat.delete"
    case chatMeMessage = "chat.meMessage"
    case chatPostEphemeral = "chat.postEphemeral"
    case chatPostMessage = "chat.postMessage"
    case chatUpdate = "chat.update"
    case conversationsArchive = "conversations.archive"
    case conversationsCreate = "conversations.create"
    case conversationsHistory = "conversations.history"
    case conversationsList = "conversations.list"
    case conversationsMembers = "conversations.members"
    case conversationsOpen = "conversations.open"
    case conversationsReplies = "conversations.replies"
    case dndInfo = "dnd.info"
    case dndTeamInfo = "dnd.teamInfo"
    case emojiList = "emoji.list"
    case filesCommentsAdd = "files.comments.add"
    case filesCommentsDelete = "files.comments.delete"
    case filesCommentsEdit = "files.comments.edit"
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
    case mpimClose = "mpim.close"
    case mpimHistory = "mpim.history"
    case mpimList = "mpim.list"
    case mpimMark = "mpim.mark"
    case mpimOpen = "mpim.open"
    case oauthAccess = "oauth.access"
    case pinsAdd = "pins.add"
    case pinsList = "pins.list"
    case pinsRemove = "pins.remove"
    case reactionsAdd = "reactions.add"
    case reactionsGet = "reactions.get"
    case reactionsList = "reactions.list"
    case reactionsRemove = "reactions.remove"
    case rtmConnect = "rtm.connect"
    case searchAll = "search.all"
    case searchFiles = "search.files"
    case searchMessages = "search.messages"
    case starsAdd = "stars.add"
    case starsRemove = "stars.remove"
    case teamInfo = "team.info"
    case usersConversations = "users.conversations"
    case usersGetPresence = "users.getPresence"
    case usersInfo = "users.info"
    case usersList = "users.list"
    case usersLookupByEmail = "users.lookupByEmail"
    case usersProfileSet = "users.profile.set"
    case usersSetActive = "users.setActive"
    case usersSetPresence = "users.setPresence"

    // MARK: - Deprecated endpoints
    case channelsArchive = "channels.archive"
    case channelsCreate = "channels.create"
    case channelsInfo = "channels.info"
    case channelsInvite = "channels.invite"
    case channelsJoin = "channels.join"
    case channelsList = "channels.list"
    case channelsMark = "channels.mark"
    case imOpen = "im.open"
}
