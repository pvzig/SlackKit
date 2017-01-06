//
// CustomProfileField.swift
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

public struct CustomProfileField {
    
    internal(set) public var id: String?
    internal(set) public var alt: String?
    internal(set) public var value: String?
    internal(set) public var hidden: Bool?
    internal(set) public var hint: String?
    internal(set) public var label: String?
    internal(set) public var options: String?
    internal(set) public var ordering: Int?
    internal(set) public var possibleValues: [String]?
    internal(set) public var type: String?
    
    internal init(field: [String: Any]?) {
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
    
    internal init(id: String?) {
        self.id = id
    }
    
    internal mutating func updateProfileField(_ profile: CustomProfileField?) {
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
