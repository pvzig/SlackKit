//
// CustomProfileField.swift
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

public struct CustomProfileField {
    public var id: String?
    public var alt: String?
    public var value: String?
    public var hidden: Bool?
    public var hint: String?
    public var label: String?
    public var options: String?
    public var ordering: Int?
    public var possibleValues: [String]?
    public var type: String?

    public init(field: [String: Any]?) {
        id = field?["id"] as? String
        alt = field?["alt"] as? String
        value = field?["value"] as? String
        hidden = field?["is_hidden"] as? Bool
        hint = field?["hint"] as? String
        label = field?["label"] as? String
        options = field?["options"] as? String
        ordering = field?["ordering"] as? Int
        possibleValues = field?["possible_values"] as? [String]
        type = field?["type"] as? String
    }

    public init(id: String?) {
        self.id = id
    }

    public mutating func updateProfileField(_ profile: CustomProfileField?) {
        id = profile?.id != nil ? profile?.id : id
        alt = profile?.alt != nil ? profile?.alt : alt
        value = profile?.value != nil ? profile?.value : value
        hidden = profile?.hidden != nil ? profile?.hidden : hidden
        hint = profile?.hint != nil ? profile?.hint : hint
        label = profile?.label != nil ? profile?.label : label
        options = profile?.options != nil ? profile?.options : options
        ordering = profile?.ordering != nil ? profile?.ordering : ordering
        possibleValues = profile?.possibleValues != nil ? profile?.possibleValues : possibleValues
        type = profile?.type != nil ? profile?.type : type
    }
}
