//
// SlackError.swift
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

public enum SlackError: String, ErrorType {
    case AccountInactive = "account_inactive"
    case AlreadyArchived = "already_archived"
    case AlreadyInChannel = "already_in_channel"
    case AlreadyPinned = "already_pinned"
    case AlreadyReacted = "already_reacted"
    case AlreadyStarred = "already_starred"
    case BadClientSecret = "bad_client_secret"
    case BadRedirectURI = "bad_redirect_uri"
    case BadTimeStamp = "bad_timestamp"
    case CantArchiveGeneral = "cant_archive_general"
    case CantDelete = "cant_delete"
    case CantDeleteFile = "cant_delete_file"
    case CantDeleteMessage = "cant_delete_message"
    case CantInvite = "cant_invite"
    case CantInviteSelf = "cant_invite_self"
    case CantKickFromGeneral = "cant_kick_from_general"
    case CantKickFromLastChannel = "cant_kick_from_last_channel"
    case CantKickSelf = "cant_kick_self"
    case CantLeaveGeneral = "cant_leave_general"
    case CantLeaveLastChannel = "cant_leave_last_channel"
    case CantUpdateMessage = "cant_update_message"
    case ChannelNotFound = "channel_not_found"
    case ComplianceExportsPreventDeletion = "compliance_exports_prevent_deletion"
    case EditWindowClosed = "edit_window_closed"
    case FileCommentNotFound = "file_comment_not_found"
    case FileDeleted = "file_deleted"
    case FileNotFound = "file_not_found"
    case FileNotShared = "file_not_shared"
    case GroupContainsOthers = "group_contains_others"
    case InvalidArgName = "invalid_arg_name"
    case InvalidArrayArg = "invalid_array_arg"
    case InvalidAuth = "invalid_auth"
    case InvalidChannel = "invalid_channel"
    case InvalidCharSet = "invalid_charset"
    case InvalidClientID = "invalid_client_id"
    case InvalidCode = "invalid_code"
    case InvalidFormData = "invalid_form_data"
    case InvalidName = "invalid_name"
    case InvalidPostType = "invalid_post_type"
    case InvalidPresence = "invalid_presence"
    case InvalidTS = "invalid_timestamp"
    case InvalidTSLatest = "invalid_ts_latest"
    case InvalidTSOldest = "invalid_ts_oldest"
    case IsArchived = "is_archived"
    case LastMember = "last_member"
    case LastRAChannel = "last_ra_channel"
    case MessageNotFound = "message_not_found"
    case MessageTooLong = "msg_too_long"
    case MigrationInProgress = "migration_in_progress"
    case MissingDuration = "missing_duration"
    case MissingPostType = "missing_post_type"
    case MissingScope = "missing_scope"
    case NameTaken = "name_taken"
    case NoChannel = "no_channel"
    case NoComment = "no_comment"
    case NoItemSpecified = "no_item_specified"
    case NoReaction = "no_reaction"
    case NoText = "no_text"
    case NotArchived = "not_archived"
    case NotAuthed = "not_authed"
    case NotEnoughUsers = "not_enough_users"
    case NotInChannel = "not_in_channel"
    case NotInGroup = "not_in_group"
    case NotPinned = "not_pinned"
    case NotStarred = "not_starred"
    case OverPaginationLimit = "over_pagination_limit"
    case PaidOnly = "paid_only"
    case PermissionDenied = "perimssion_denied"
    case PostingToGeneralChannelDenied = "posting_to_general_channel_denied"
    case RateLimited = "rate_limited"
    case RequestTimeout = "request_timeout"
    case RestrictedAction = "restricted_action"
    case SnoozeEndFailed = "snooze_end_failed"
    case SnoozeFailed = "snooze_failed"
    case SnoozeNotActive = "snooze_not_active"
    case TooLong = "too_long"
    case TooManyEmoji = "too_many_emoji"
    case TooManyReactions = "too_many_reactions"
    case TooManyUsers = "too_many_users"
    case UnknownError
    case UnknownType = "unknown_type"
    case UserDisabled = "user_disabled"
    case UserDoesNotOwnChannel = "user_does_not_own_channel"
    case UserIsBot = "user_is_bot"
    case UserIsRestricted = "user_is_restricted"
    case UserIsUltraRestricted = "user_is_ultra_restricted"
    case UserListNotSupplied = "user_list_not_supplied"
    case UserNotFound = "user_not_found"
    case UserNotVisible = "user_not_visible"
    // Client
    case ClientNetworkError
    case ClientJSONError
    case ClientOAuthError
    // HTTP
    case TooManyRequests
    case UnknownHTTPError
}
