//
// SKCoreTests.swift
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

import XCTest
@testable import SKCore

final class SKCoreTests: XCTestCase {

    static var rootPath: String {
        #if Xcode
        return Bundle(for: self).resourcePath!
        #else
        return "SlackKitTests/Resources"
        #endif
    }

    struct JSONData {
        static let channel          = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/channel.json"))
        static let conversation     = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/conversation.json"))
        static let file             = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/file.json"))
        static let group            = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/group.json"))
        static let im               = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/im.json"))
        static let mpim             = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/mpim.json"))
        static let user             = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/user.json"))
        static let usergroup        = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/usergroup.json"))
        static let events           = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/events.json"))
        static let action           = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/action.json"))
        static let attachment       = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/attachment.json"))
        static let attachmentfield  = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/attachmentfield.json"))
        static let customprofilefield = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/customprofilefield.json"))
        static let donotdisturbstatus = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/donotdisturbstatus.json"))
        static let edited           = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/edited.json"))
        static let reply            = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/reply.json"))
        static let teamicon         = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/teamicon.json"))
        static let topic            = try! Data(contentsOf: URL(fileURLWithPath: "\(rootPath)/topic.json"))
    }

    static var allTests = [
        ("testChannel", testChannel),
        ("testConversation", testConversation),
        ("testFile", testFile),
        ("testGroup", testGroup),
        ("testIm", testIm),
        ("TestMpim", testMpim),
        ("testUser", testUser),
        ("testUserGroup", testUserGroup),
        ("testEvents", testEvents),
        ("testActionCodable", testActionCodable),
        ("testAttachmentCodable", testAttachmentCodable),
        ("testAttachmentFieldCodable", testAttachmentFieldCodable),
        ("testCustomProfileFieldCodable", testCustomProfileFieldCodable),
        ("testDoNotDisturbStatusCodable", testDoNotDisturbStatusCodable),
        ("testEditedCodable", testEditedCodable),
        ("testReplyCodable", testReplyCodable),
        ("testTeamIconCodable", testTeamIconCodable),
        ("testTopicCodable", testTopicCodable)
    ]
  
  func testEvents() {
    let eventsKeys = [
        // Bot Event
        "bot_added","bot_changed",
        // Channel Event
        "channel_archive","channel_created","channel_deleted",
        "channel_joined", "channel_left", "channel_marked",
        "channel_rename","channel_unarchive",
        // Group Event
        "group_archive","group_close","group_joined",
        "group_left", "group_marked","group_rename","group_unarchive",
        // Im Event
        "im_close","im_created","im_marked","im_open", "manual_presence_change",
        // Message Event
        "message::channel_join", "message::channel_leave", "message::channel_name",
        "message::group_join", "message::group_name", "message::group_unarchive",
        "message::message_changed", "message::message_deleted",
        // Preference Event
        "pref_change", "presence_change",
        // Reaction Event
        "reaction_added", "reaction_removed",
        // Team Event
        "team_domain_change", "team_join", "team_pref_change",
        "team_rename",
        // User Event
        "user_change", "user_typing"
    ]

    let data = JSONData.events
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    _ = eventsKeys.map { json[$0] as! [String: Any] }.map { Event($0) }
  }
  
  func testChannel() {
    let data = JSONData.channel
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    let channel = Channel(channel: json)
    XCTAssertNotNil(channel)
  }
  
  func testConversation() {
    let data = JSONData.conversation
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    let channel = Channel(channel: json["channel"] as?[String : Any])
    XCTAssertNotNil(channel)
  }
  
  func testFile() {
    let data = JSONData.file
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
    let file = File(file: json)
    XCTAssertNotNil(file)
  }
  
  func testGroup() {
    let data = JSONData.group
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    let channel = Channel(channel: json)
    XCTAssertNotNil(channel)
  }
  
  func testIm() {
    let data = JSONData.im
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    let channel = Channel(channel: json)
    XCTAssertNotNil(channel)
  }
  
  func testMpim() {
    let data = JSONData.mpim
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    let channel = Channel(channel: json)
    XCTAssertNotNil(channel)
  }
  
  func testUser() {
    let data = JSONData.user
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    let user = User(user: json)
    XCTAssertNotNil(user)
  }
  
  func testUserGroup() {
    let data = JSONData.usergroup
    let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    let userGroup = UserGroup(userGroup: json)
    XCTAssertNotNil(userGroup)
  }

  func testActionCodable() {
    let data = JSONData.action
    let decoder = JSONDecoder()
    let actionByDecoder = try? decoder.decode(Action.self, from: data)
    XCTAssertNotNil(actionByDecoder)
    XCTAssertNotNil(actionByDecoder!.name)
    XCTAssertNotNil(actionByDecoder!.text)
    XCTAssertNotNil(actionByDecoder!.type)
    XCTAssertNotNil(actionByDecoder!.value)
    XCTAssertNotNil(actionByDecoder!.url)
    XCTAssertNotNil(actionByDecoder!.style)
    XCTAssertNotNil(actionByDecoder!.confirm)
    XCTAssertNotNil(actionByDecoder!.options)
    XCTAssertNotNil(actionByDecoder!.dataSource)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(actionByDecoder!)
    XCTAssertNotNil(jsonData)
    let action = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(action)
    let actionBySerialization = Action(action: action)
    XCTAssertEqual(actionBySerialization.name, actionByDecoder!.name)
    XCTAssertEqual(actionBySerialization.text, actionByDecoder!.text)
    XCTAssertEqual(actionBySerialization.type, actionByDecoder!.type)
    XCTAssertEqual(actionBySerialization.value, actionByDecoder!.value)
    XCTAssertEqual(actionBySerialization.url, actionByDecoder!.url)
    XCTAssertEqual(actionBySerialization.style, actionByDecoder!.style)
    XCTAssertEqual(actionBySerialization.options?.count, actionByDecoder!.options?.count)
    XCTAssertEqual(actionBySerialization.dataSource, actionByDecoder!.dataSource)
  }

  func testAttachmentCodable() {
    let data = JSONData.attachment
    let decoder = JSONDecoder()
    let attachmentByDecoder = try? decoder.decode(Attachment.self, from: data)
    XCTAssertNotNil(attachmentByDecoder)
    XCTAssertNotNil(attachmentByDecoder!.fallback)
    XCTAssertNotNil(attachmentByDecoder!.callbackID)
    XCTAssertNotNil(attachmentByDecoder!.type)
    XCTAssertNotNil(attachmentByDecoder!.color)
    XCTAssertNotNil(attachmentByDecoder!.pretext)
    XCTAssertNotNil(attachmentByDecoder!.authorName)
    XCTAssertNotNil(attachmentByDecoder!.authorLink)
    XCTAssertNotNil(attachmentByDecoder!.authorIcon)
    XCTAssertNotNil(attachmentByDecoder!.title)
    XCTAssertNotNil(attachmentByDecoder!.titleLink)
    XCTAssertNotNil(attachmentByDecoder!.text)
    XCTAssertNotNil(attachmentByDecoder!.fields)
    XCTAssertNotNil(attachmentByDecoder!.actions)
    XCTAssertNotNil(attachmentByDecoder!.imageURL)
    XCTAssertNotNil(attachmentByDecoder!.thumbURL)
    XCTAssertNotNil(attachmentByDecoder!.footer)
    XCTAssertNotNil(attachmentByDecoder!.footerIcon)
    XCTAssertNotNil(attachmentByDecoder!.ts)
    XCTAssertNotNil(attachmentByDecoder!.markdownEnabledFields)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(attachmentByDecoder!)
    XCTAssertNotNil(jsonData)
    let attachment = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(attachment)
    let attachmentBySerialization = Attachment(attachment: attachment)
    XCTAssertEqual(attachmentBySerialization.fallback, attachmentByDecoder!.fallback)
    XCTAssertEqual(attachmentBySerialization.callbackID, attachmentByDecoder!.callbackID)
    XCTAssertEqual(attachmentBySerialization.type, attachmentByDecoder!.type)
    XCTAssertEqual(attachmentBySerialization.color, attachmentByDecoder!.color)
    XCTAssertEqual(attachmentBySerialization.pretext, attachmentByDecoder!.pretext)
    XCTAssertEqual(attachmentBySerialization.authorName, attachmentByDecoder!.authorName)
    XCTAssertEqual(attachmentBySerialization.authorLink, attachmentByDecoder!.authorLink)
    XCTAssertEqual(attachmentBySerialization.authorIcon, attachmentByDecoder!.authorIcon)
    XCTAssertEqual(attachmentBySerialization.title, attachmentByDecoder!.title)
    XCTAssertEqual(attachmentBySerialization.titleLink, attachmentByDecoder!.titleLink)
    XCTAssertEqual(attachmentBySerialization.text, attachmentByDecoder!.text)
    XCTAssertEqual(attachmentBySerialization.fields, attachmentByDecoder!.fields)
    XCTAssertEqual(attachmentBySerialization.actions, attachmentByDecoder!.actions)
    XCTAssertEqual(attachmentBySerialization.imageURL, attachmentByDecoder!.imageURL)
    XCTAssertEqual(attachmentBySerialization.thumbURL, attachmentByDecoder!.thumbURL)
    XCTAssertEqual(attachmentBySerialization.footer, attachmentByDecoder!.footer)
    XCTAssertEqual(attachmentBySerialization.footerIcon, attachmentByDecoder!.footerIcon)
    XCTAssertEqual(attachmentBySerialization.ts, attachmentByDecoder!.ts)
    XCTAssertEqual(attachmentBySerialization.markdownEnabledFields, attachmentByDecoder!.markdownEnabledFields)
  }
    
  func testAttachmentFieldCodable() {
    let data = JSONData.attachmentfield
    let decoder = JSONDecoder()
    let attachmentFieldByDecoder = try? decoder.decode(AttachmentField.self, from: data)
    XCTAssertNotNil(attachmentFieldByDecoder)
    XCTAssertNotNil(attachmentFieldByDecoder!.title)
    XCTAssertNotNil(attachmentFieldByDecoder!.value)
    XCTAssertNotNil(attachmentFieldByDecoder!.short)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(attachmentFieldByDecoder!)
    XCTAssertNotNil(jsonData)
    let field = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(field)
    let attachmentFieldBySerialization = AttachmentField(field: field)
    XCTAssertEqual(attachmentFieldBySerialization.title, attachmentFieldByDecoder!.title)
    XCTAssertEqual(attachmentFieldBySerialization.value, attachmentFieldByDecoder!.value)
    XCTAssertEqual(attachmentFieldBySerialization.short, attachmentFieldByDecoder!.short)
  }
    
  func testCustomProfileFieldCodable() {
    let data = JSONData.customprofilefield
    let decoder = JSONDecoder()
    let customProfileFieldByDecoder = try? decoder.decode(CustomProfileField.self, from: data)
    XCTAssertNotNil(customProfileFieldByDecoder)
    XCTAssertNotNil(customProfileFieldByDecoder!.id)
    XCTAssertNotNil(customProfileFieldByDecoder!.alt)
    XCTAssertNotNil(customProfileFieldByDecoder!.value)
    XCTAssertNotNil(customProfileFieldByDecoder!.hidden)
    XCTAssertNotNil(customProfileFieldByDecoder!.hint)
    XCTAssertNotNil(customProfileFieldByDecoder!.label)
    XCTAssertNotNil(customProfileFieldByDecoder!.options)
    XCTAssertNotNil(customProfileFieldByDecoder!.ordering)
    XCTAssertNotNil(customProfileFieldByDecoder!.possibleValues)
    XCTAssertNotNil(customProfileFieldByDecoder!.type)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(customProfileFieldByDecoder!)
    XCTAssertNotNil(jsonData)
    let field = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(field)
    let customProfileFieldBySerialization = CustomProfileField(field: field)
    XCTAssertEqual(customProfileFieldBySerialization.id, customProfileFieldByDecoder!.id)
    XCTAssertEqual(customProfileFieldBySerialization.alt, customProfileFieldByDecoder!.alt)
    XCTAssertEqual(customProfileFieldBySerialization.value, customProfileFieldByDecoder!.value)
    XCTAssertEqual(customProfileFieldBySerialization.hidden, customProfileFieldByDecoder!.hidden)
    XCTAssertEqual(customProfileFieldBySerialization.hint, customProfileFieldByDecoder!.hint)
    XCTAssertEqual(customProfileFieldBySerialization.label, customProfileFieldByDecoder!.label)
    XCTAssertEqual(customProfileFieldBySerialization.options, customProfileFieldByDecoder!.options)
    XCTAssertEqual(customProfileFieldBySerialization.ordering, customProfileFieldByDecoder!.ordering)
    XCTAssertEqual(customProfileFieldBySerialization.possibleValues, customProfileFieldByDecoder!.possibleValues)
    XCTAssertEqual(customProfileFieldBySerialization.type, customProfileFieldByDecoder!.type)
  }
    
  func testDoNotDisturbStatusCodable() {
    let data = JSONData.donotdisturbstatus
    let decoder = JSONDecoder()
    let doNotDisturbStatusByDecoder = try? decoder.decode(DoNotDisturbStatus.self, from: data)
    XCTAssertNotNil(doNotDisturbStatusByDecoder)
    XCTAssertNotNil(doNotDisturbStatusByDecoder!.enabled)
    XCTAssertNotNil(doNotDisturbStatusByDecoder!.nextDoNotDisturbStart)
    XCTAssertNotNil(doNotDisturbStatusByDecoder!.nextDoNotDisturbEnd)
    XCTAssertNotNil(doNotDisturbStatusByDecoder!.snoozeEnabled)
    XCTAssertNotNil(doNotDisturbStatusByDecoder!.snoozeEndtime)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(doNotDisturbStatusByDecoder!)
    XCTAssertNotNil(jsonData)
    let status = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(status)
    let doNotDisturbStatusBySerialization = DoNotDisturbStatus(status: status)
    XCTAssertEqual(doNotDisturbStatusBySerialization.enabled, doNotDisturbStatusByDecoder!.enabled)
    XCTAssertEqual(doNotDisturbStatusBySerialization.nextDoNotDisturbStart, doNotDisturbStatusByDecoder!.nextDoNotDisturbStart)
    XCTAssertEqual(doNotDisturbStatusBySerialization.nextDoNotDisturbEnd, doNotDisturbStatusByDecoder!.nextDoNotDisturbEnd)
    XCTAssertEqual(doNotDisturbStatusBySerialization.snoozeEnabled, doNotDisturbStatusByDecoder!.snoozeEnabled)
    XCTAssertEqual(doNotDisturbStatusBySerialization.snoozeEndtime, doNotDisturbStatusByDecoder!.snoozeEndtime)
  }
    
  func testEditedCodable() {
    let data = JSONData.edited
    let decoder = JSONDecoder()
    let editedByDecoder = try? decoder.decode(Edited.self, from: data)
    XCTAssertNotNil(editedByDecoder)
    XCTAssertNotNil(editedByDecoder!.user)
    XCTAssertNotNil(editedByDecoder!.ts)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(editedByDecoder!)
    XCTAssertNotNil(jsonData)
    let edited = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(edited)
    let editedBySerialization = Edited(edited: edited)
    XCTAssertEqual(editedBySerialization.user, editedByDecoder!.user)
    XCTAssertEqual(editedBySerialization.ts, editedByDecoder!.ts)
  }
    
  func testReplyCodable() {
    let data = JSONData.reply
    let decoder = JSONDecoder()
    let replyByDecoder = try? decoder.decode(Reply.self, from: data)
    XCTAssertNotNil(replyByDecoder)
    XCTAssertNotNil(replyByDecoder!.user)
    XCTAssertNotNil(replyByDecoder!.ts)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(replyByDecoder!)
    XCTAssertNotNil(jsonData)
    let reply = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(reply)
    let replyBySerialization = Reply(reply: reply)
    XCTAssertEqual(replyBySerialization.user, replyByDecoder!.user)
    XCTAssertEqual(replyBySerialization.ts, replyByDecoder!.ts)
  }
    
  func testTeamIconCodable() {
    let data = JSONData.teamicon
    let decoder = JSONDecoder()
    let teamIconByDecoder = try? decoder.decode(TeamIcon.self, from: data)
    XCTAssertNotNil(teamIconByDecoder)
    XCTAssertNotNil(teamIconByDecoder!.image34)
    XCTAssertNotNil(teamIconByDecoder!.image44)
    XCTAssertNotNil(teamIconByDecoder!.image68)
    XCTAssertNotNil(teamIconByDecoder!.image88)
    XCTAssertNotNil(teamIconByDecoder!.image102)
    XCTAssertNotNil(teamIconByDecoder!.image132)
    XCTAssertNotNil(teamIconByDecoder!.imageOriginal)
    XCTAssertNotNil(teamIconByDecoder!.imageDefault)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(teamIconByDecoder!)
    XCTAssertNotNil(jsonData)
    let icon = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(icon)
    let teamIconBySerialization = TeamIcon(icon: icon)
    XCTAssertEqual(teamIconBySerialization.image34, teamIconByDecoder!.image34)
    XCTAssertEqual(teamIconBySerialization.image44, teamIconByDecoder!.image44)
    XCTAssertEqual(teamIconBySerialization.image68, teamIconByDecoder!.image68)
    XCTAssertEqual(teamIconBySerialization.image88, teamIconByDecoder!.image88)
    XCTAssertEqual(teamIconBySerialization.image102, teamIconByDecoder!.image102)
    XCTAssertEqual(teamIconBySerialization.image132, teamIconByDecoder!.image132)
    XCTAssertEqual(teamIconBySerialization.imageOriginal, teamIconByDecoder!.imageOriginal)
    XCTAssertEqual(teamIconBySerialization.imageDefault, teamIconByDecoder!.imageDefault)
  }
    
  func testTopicCodable() {
    let data = JSONData.topic
    let decoder = JSONDecoder()
    let topicByDecoder = try? decoder.decode(Topic.self, from: data)
    XCTAssertNotNil(topicByDecoder)
    XCTAssertNotNil(topicByDecoder!.value)
    XCTAssertNotNil(topicByDecoder!.creator)
    XCTAssertNotNil(topicByDecoder!.lastSet)
    let encoder = JSONEncoder()
    let jsonData = try? encoder.encode(topicByDecoder!)
    XCTAssertNotNil(jsonData)
    let topic = try? JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String: Any]
    XCTAssertNotNil(topic)
    let topicBySerialization = Topic(topic: topic)
    XCTAssertEqual(topicBySerialization.value, topicByDecoder!.value)
    XCTAssertEqual(topicBySerialization.creator, topicByDecoder!.creator)
    XCTAssertEqual(topicBySerialization.lastSet, topicByDecoder!.lastSet)
  }
}
