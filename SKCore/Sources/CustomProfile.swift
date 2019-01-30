//
// CustomProfile.swift
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

public struct CustomProfile {
    public var fields = [String: CustomProfileField]()

    public init(profile: [String: Any]?) {
        if let eventFields = profile?["fields"] as? [Any] {
            for field in eventFields {
                var cpf: CustomProfileField?
                if let fieldDictionary = field as? [String: Any] {
                    cpf = CustomProfileField(field: fieldDictionary)
                } else {
                    cpf = CustomProfileField(id: field as? String)
                }
                if let id = cpf?.id { fields[id] = cpf }
            }
        }
    }

    public init(customFields: [String: Any]?) {
        if let customFields = customFields {
            for key in customFields.keys {
                let cpf = CustomProfileField(field: customFields[key] as? [String: Any])
                self.fields[key] = cpf
            }
        }
    }
}
