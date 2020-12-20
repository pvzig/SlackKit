//
// AttachmentField.swift
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

public struct AttachmentField {
    fileprivate enum CodingKeys: String {
        case title
        case value
        case short
    }
    
    public let title: String?
    public let value: String?
    public let short: Bool?
    
    public init(field: [String: Any]?) {
        title = field?[CodingKeys.title] as? String
        value = field?[CodingKeys.value] as? String
        short = field?[CodingKeys.short] as? Bool
    }

    public init(title: String?, value: String?, short: Bool? = nil) {
        self.title = title
        self.value = value
        self.short = short
    }

    public var dictionary: [String: Any] {
        var field = [String: Any]()
        field[CodingKeys.title] = title
        field[CodingKeys.value] = value
        field[CodingKeys.short] = short
        return field
    }
}

extension AttachmentField: Codable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        short = try values.decodeIfPresent(Bool.self, forKey: .short)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(value, forKey: .value)
        try container.encode(short, forKey: .short)
    }
}

extension AttachmentField.CodingKeys: CodingKey { }

extension AttachmentField: Equatable { }
