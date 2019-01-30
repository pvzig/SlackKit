//
// Action.swift
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

public struct Action {
    public let name: String?
    public let text: String?
    public let type: String?
    public let value: String?
    public let url: String?
    public let style: ActionStyle?
    public let confirm: Confirm?
    public let options: [Option]?
    public let dataSource: DataSource?

    public init(action: [String: Any]?) {
        name = action?["name"] as? String
        text = action?["text"] as? String
        type = action?["type"] as? String
        value = action?["value"] as? String
        url = action?["url"] as? String
        style = ActionStyle(rawValue: action?["style"] as? String ?? "")
        confirm = Confirm(confirm:action?["confirm"] as? [String: Any])
        options = (action?["options"] as? [[String: Any]])?.map { Option(option: $0) }
        dataSource = DataSource(rawValue: action?["data_source"] as? String ?? "")
    }

    public init(name: String, text: String, type: String = "button", style: ActionStyle = .defaultStyle, value: String? = nil,
                url: String? = nil, confirm: Confirm? = nil, options: [Option]? = nil, dataSource: DataSource? = nil) {
        self.name = name
        self.text = text
        self.type = type
        self.value = value
        self.url = url
        self.style = style
        self.confirm = confirm
        self.options = options
        self.dataSource = dataSource
    }

    public var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["name"] = name
        dict["text"] = text
        dict["type"] = type
        dict["value"] = value
        dict["url"] = url
        dict["style"] = style?.rawValue
        dict["confirm"] = confirm?.dictionary
        dict["options"] = options?.map { $0.dictionary }
        dict["data_source"] = dataSource?.rawValue
        return dict
    }

    public struct Confirm {
        public let title: String?
        public let text: String?
        public let okText: String?
        public let dismissText: String?

        public init(confirm: [String: Any]?) {
            title = confirm?["title"] as? String
            text = confirm?["text"] as? String
            okText = confirm?["ok_text"] as? String
            dismissText = confirm?["dismiss_text"] as? String
        }

        public init(text: String, title: String? = nil, okText: String? = nil, dismissText: String? = nil) {
            self.text = text
            self.title = title
            self.okText = okText
            self.dismissText = dismissText
        }

        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict["title"] = title
            dict["text"] = text
            dict["ok_text"] = okText
            dict["dismiss_text"] = dismissText
            return dict
        }
    }

    public struct Option {
        public let text: String?
        public let value: String?

        public init(option: [String: Any]?) {
            text = option?["text"] as? String
            value = option?["value"] as? String
        }

        public init(text: String, value: String) {
            self.text = text
            self.value = value
        }

        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict["text"] = text
            dict["value"] = value
            return dict
        }
    }

    public enum DataSource: String {
        case users
        case channels
        case conversations
    }
}

public enum ActionStyle: String {
    case defaultStyle = "default"
    case primary = "primary"
    case danger = "danger"
}

public enum MessageResponseType: String {
    case inChannel = "in_channel"
    case ephemeral = "ephemeral"
}
