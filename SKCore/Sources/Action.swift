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
    fileprivate enum CodingKeys: String {
        case name
        case text
        case type
        case value
        case url
        case style
        case confirm
        case options
        case dataSource = "data_source"
    }
    
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
        name = action?[CodingKeys.name] as? String
        text = action?[CodingKeys.text] as? String
        type = action?[CodingKeys.type] as? String
        value = action?[CodingKeys.value] as? String
        url = action?[CodingKeys.url] as? String
        style = ActionStyle(rawValue: action?[CodingKeys.style] as? String ?? "")
        confirm = Confirm(confirm:action?[CodingKeys.confirm] as? [String: Any])
        options = (action?[CodingKeys.options] as? [[String: Any]])?.map { Option(option: $0) }
        dataSource = DataSource(rawValue: action?[CodingKeys.dataSource] as? String ?? "")
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
        dict[CodingKeys.name] = name
        dict[CodingKeys.text] = text
        dict[CodingKeys.type] = type
        dict[CodingKeys.value] = value
        dict[CodingKeys.url] = url
        dict[CodingKeys.style] = style?.rawValue
        dict[CodingKeys.confirm] = confirm?.dictionary
        dict[CodingKeys.options] = options?.map { $0.dictionary }
        dict[CodingKeys.dataSource] = dataSource?.rawValue
        return dict
    }

    public struct Confirm {
        fileprivate enum CodingKeys: String {
            case title
            case text
            case okText = "ok_text"
            case dismissText = "dismiss_text"
        }
        
        public let title: String?
        public let text: String?
        public let okText: String?
        public let dismissText: String?
        
        public init(confirm: [String: Any]?) {
            title = confirm?[CodingKeys.title] as? String
            text = confirm?[CodingKeys.text] as? String
            okText = confirm?[CodingKeys.okText] as? String
            dismissText = confirm?[CodingKeys.dismissText] as? String
        }

        public init(text: String, title: String? = nil, okText: String? = nil, dismissText: String? = nil) {
            self.text = text
            self.title = title
            self.okText = okText
            self.dismissText = dismissText
        }

        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict[CodingKeys.title] = title
            dict[CodingKeys.text] = text
            dict[CodingKeys.okText] = okText
            dict[CodingKeys.dismissText] = dismissText
            return dict
        }
    }

    public struct Option {
        fileprivate enum CodingKeys: String {
            case text
            case value
        }
        
        public let text: String?
        public let value: String?
        
        public init(option: [String: Any]?) {
            text = option?[CodingKeys.text] as? String
            value = option?[CodingKeys.value] as? String
        }

        public init(text: String, value: String) {
            self.text = text
            self.value = value
        }

        public var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict[CodingKeys.text] = text
            dict[CodingKeys.value] = value
            return dict
        }
    }

    public enum DataSource: String, Codable {
        case users
        case channels
        case conversations
    }
}

extension Action: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        style = try values.decodeIfPresent(ActionStyle.self, forKey: .style)
        confirm = try values.decodeIfPresent(Confirm.self, forKey: .confirm)
        options = try values.decodeIfPresent([Option].self, forKey: .options)
        dataSource = try values.decodeIfPresent(DataSource.self, forKey: .dataSource)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(text, forKey: .text)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
        try container.encode(url, forKey: .url)
        try container.encode(style, forKey: .style)
        try container.encode(confirm, forKey: .confirm)
        try container.encode(options, forKey: .options)
        try container.encode(dataSource, forKey: .dataSource)
    }
}

extension Action.CodingKeys: CodingKey { }

extension Action.Confirm: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        okText = try values.decodeIfPresent(String.self, forKey: .okText)
        dismissText = try values.decodeIfPresent(String.self, forKey: .dismissText)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(text, forKey: .text)
        try container.encode(okText, forKey: .okText)
        try container.encode(dismissText, forKey: .dismissText)
    }
}

extension Action.Confirm.CodingKeys: CodingKey { }

extension Action.Option: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(text, forKey: .text)
        try container.encode(value, forKey: .value)
    }
}

extension Action.Option.CodingKeys: CodingKey { }

extension Action: Equatable { }
extension Action.Confirm: Equatable { }
extension Action.Option: Equatable { }

public enum ActionStyle: String, Codable {
    case defaultStyle = "default"
    case primary = "primary"
    case danger = "danger"
}

public enum MessageResponseType: String, Codable {
    case inChannel = "in_channel"
    case ephemeral = "ephemeral"
}
