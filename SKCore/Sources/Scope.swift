//
// Scope.swift
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

public enum Scope: String {
    case channelsHistory = "channels:history"
    case channelsRead = "channels:read"
    case channelsWrite = "channels:write"
    case chatWriteBot = "chat:write:bot"
    case chatWriteUser = "chat:write:user"
    case dndRead = "dnd:read"
    case dndWrite = "dnd:write"
    case emojiRead = "emoji:read"
    case filesRead = "files:read"
    case filesWriteUser = "files:write:user"
    case groupsHistory = "groups:history"
    case groupsRead = "groups:read"
    case groupsWrite = "groups:write"
    case identityBasic = "identity.basic"
    case imHistory = "im:history"
    case imRead = "im:read"
    case imWrite = "im:write"
    case mpimHistory = "mpim:history"
    case mpimRead = "mpim:read"
    case mpimWrite = "mpim:write"
    case pinsRead = "pins:read"
    case pinsWrite = "pins:write"
    case reactionsRead = "reactions:read"
    case reactionsWrite = "reactions:write"
    case remindersRead = "reminders:read"
    case remindersWrite = "reminders:write"
    case searchRead = "search:read"
    case starsRead = "stars:read"
    case starsWrite = "stars:write"
    case teamRead = "team:read"
    case userGroupsRead = "usergroups:read"
    case userGroupsWrite = "usergroups:write"
    case userProfilesRead = "user.profiles:read"
    case userProfilesWrite = "user.profiles:write"
    case usersRead = "users:read"
    case usersReadEmail = "users:read.email"
    case usersWrite = "users:write"
    case incomingWebhook = "incoming-webhook"
    case commands = "commands"
    case bot = "bot"
    case identify = "identify"
    case client = "client"
    case admin = "admin"
    //Deprecated
    case read = "read"
    case post = "post"
}
