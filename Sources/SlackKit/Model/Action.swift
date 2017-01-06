//
// Action.swift
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

public struct Action {
    
    public let name: String?
    public let text: String?
    public let type: String?
    public let value: String?
    public let style: ActionStyle?
    public let confirm: Confirm?
    
    internal init(action:[String: Any]?) {
        name = action?["name"] as? String
        text = action?["text"] as? String
        type = action?["type"] as? String
        value = action?["value"] as? String
        style = ActionStyle(rawValue: action?["style"] as? String ?? "")
        confirm = Confirm(confirm:action?["confirm"] as? [String: Any])
    }
    
    public init(name: String, text: String, style: ActionStyle = .defaultStyle, value: String? = nil, confirm: Confirm? = nil) {
        self.type = "button"
        self.name = name
        self.text = text
        self.value = value
        self.style = style
        self.confirm = confirm
    }
    
    internal var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["name"] = name
        dict["text"] = text
        dict["type"] = type
        dict["value"] = value
        dict["style"] = style?.rawValue
        dict["confirm"] = confirm?.dictionary
        return dict
    }
    
    public struct Confirm {
        
        public let title: String?
        public let text: String?
        public let okText: String?
        public let dismissText: String?
        
        internal init(confirm:[String: Any]?) {
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
        
        internal var dictionary: [String: Any] {
            var dict = [String: Any]()
            dict["title"] = title
            dict["text"] = text
            dict["ok_text"] = okText
            dict["dismiss_text"] = dismissText
            return dict
        }
    }
}

public enum ActionStyle: String {
    case defaultStyle = "default"
    case primary = "primary"
    case danger = "danger"
}

public enum ResponseType: String {
    case inChannel = "in_channel"
    case ephemeral = "ephemeral"
}
