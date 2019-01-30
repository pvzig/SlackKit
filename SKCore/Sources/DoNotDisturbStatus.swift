//
// DoNotDisturbStatus.swift
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

public struct DoNotDisturbStatus {
    public var enabled: Bool?
    public var nextDoNotDisturbStart: Int?
    public var nextDoNotDisturbEnd: Int?
    public var snoozeEnabled: Bool?
    public var snoozeEndtime: Int?

    public init(status: [String: Any]?) {
        enabled = status?["dnd_enabled"] as? Bool
        nextDoNotDisturbStart = status?["next_dnd_start_ts"] as? Int
        nextDoNotDisturbEnd = status?["next_dnd_end_ts"] as? Int
        snoozeEnabled = status?["snooze_enabled"] as? Bool
        snoozeEndtime = status?["snooze_endtime"] as? Int
    }
}
