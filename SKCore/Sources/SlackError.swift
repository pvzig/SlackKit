//
// SlackError.swift
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

public enum SlackError: String, Error {
    case accountInactive = "account_inactive"
    case alreadyArchived = "already_archived"
    case alreadyInChannel = "already_in_channel"
    case alreadyPinned = "already_pinned"
    case alreadyReacted = "already_reacted"
    case alreadyStarred = "already_starred"
    case badClientSecret = "bad_client_secret"
    case badRedirectURI = "bad_redirect_uri"
    case badTimeStamp = "bad_timestamp"
    case cantArchiveGeneral = "cant_archive_general"
    case cantDelete = "cant_delete"
    case cantDeleteFile = "cant_delete_file"
    case cantDeleteMessage = "cant_delete_message"
    case cantInvite = "cant_invite"
    case cantInviteSelf = "cant_invite_self"
    case cantKickFromGeneral = "cant_kick_from_general"
    case cantKickFromLastChannel = "cant_kick_from_last_channel"
    case cantKickSelf = "cant_kick_self"
    case cantLeaveGeneral = "cant_leave_general"
    case cantLeaveLastChannel = "cant_leave_last_channel"
    case cantUpdateMessage = "cant_update_message"
    case channelNotFound = "channel_not_found"
    case complianceExportsPreventDeletion = "compliance_exports_prevent_deletion"
    case editWindowClosed = "edit_window_closed"
    case fileCommentNotFound = "file_comment_not_found"
    case fileDeleted = "file_deleted"
    case fileNotFound = "file_not_found"
    case fileNotShared = "file_not_shared"
    case groupContainsOthers = "group_contains_others"
    case invalidArgName = "invalid_arg_name"
    case invalidArrayArg = "invalid_array_arg"
    case invalidAuth = "invalid_auth"
    case invalidChannel = "invalid_channel"
    case invalidCharSet = "invalid_charset"
    case invalidClientID = "invalid_client_id"
    case invalidCode = "invalid_code"
    case invalidFormData = "invalid_form_data"
    case invalidName = "invalid_name"
    case invalidPostType = "invalid_post_type"
    case invalidPresence = "invalid_presence"
    case invalidTS = "invalid_timestamp"
    case invalidTSLatest = "invalid_ts_latest"
    case invalidTSOldest = "invalid_ts_oldest"
    case isArchived = "is_archived"
    case lastMember = "last_member"
    case lastRAChannel = "last_ra_channel"
    case messageNotFound = "message_not_found"
    case messageTooLong = "msg_too_long"
    case migrationInProgress = "migration_in_progress"
    case missingDuration = "missing_duration"
    case missingPostType = "missing_post_type"
    case missingScope = "missing_scope"
    case nameTaken = "name_taken"
    case noChannel = "no_channel"
    case noComment = "no_comment"
    case noItemSpecified = "no_item_specified"
    case noReaction = "no_reaction"
    case noText = "no_text"
    case notArchived = "not_archived"
    case notAuthed = "not_authed"
    case notEnoughUsers = "not_enough_users"
    case notInChannel = "not_in_channel"
    case notInGroup = "not_in_group"
    case notPinned = "not_pinned"
    case notStarred = "not_starred"
    case overPaginationLimit = "over_pagination_limit"
    case paidOnly = "paid_only"
    case permissionDenied = "perimssion_denied"
    case postingToGeneralChannelDenied = "posting_to_general_channel_denied"
    case rateLimited = "rate_limited"
    case requestTimeout = "request_timeout"
    case restrictedAction = "restricted_action"
    case snoozeEndFailed = "snooze_end_failed"
    case snoozeFailed = "snooze_failed"
    case snoozeNotActive = "snooze_not_active"
    case teamAddedToOrg = "team_added_to_org"
    case tooLong = "too_long"
    case tooManyEmoji = "too_many_emoji"
    case tooManyReactions = "too_many_reactions"
    case tooManyUsers = "too_many_users"
    case unknownError
    case unknownType = "unknown_type"
    case userDisabled = "user_disabled"
    case userDoesNotOwnChannel = "user_does_not_own_channel"
    case userIsBot = "user_is_bot"
    case userIsRestricted = "user_is_restricted"
    case userIsUltraRestricted = "user_is_ultra_restricted"
    case userListNotSupplied = "user_list_not_supplied"
    case userNotFound = "user_not_found"
    case userNotVisible = "user_not_visible"
    // Client
    case clientNetworkError
    case clientJSONError
    case clientOAuthError
    // HTTP
    case tooManyRequests
    case unknownHTTPError
    // RTM
    case rtmConnectionError
}
