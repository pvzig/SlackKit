//
// TeamIcon.swift
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

public struct TeamIcon {
    public var image34: String?
    public var image44: String?
    public var image68: String?
    public var image88: String?
    public var image102: String?
    public var image132: String?
    public var imageOriginal: String?
    public var imageDefault: Bool?

    public init(icon: [String: Any]?) {
        image34 = icon?["image_34"] as? String
        image44 = icon?["image_44"] as? String
        image68 = icon?["image_68"] as? String
        image88 = icon?["image_88"] as? String
        image102 = icon?["image_102"] as? String
        image132 = icon?["image_132"] as? String
        imageOriginal = icon?["image_original"] as? String
        imageDefault = icon?["image_default"] as? Bool
    }
}
