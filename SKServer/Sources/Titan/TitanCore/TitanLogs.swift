//   Copyright 2017 Enervolution GmbH
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
import Foundation

public protocol TitanLogger {

    /// log something generally unimportant (lowest priority)
    func verbose(_ string: String)

    /// log something which help during debugging (low priority)
    func debug(_ string: String)

    /// log something which you are really interested but which is not an issue or error (normal priority)
    func info(_ string: String)

     /// log something which may cause big trouble soon (high priority)
    func warning(_ string: String)

    /// log something which will keep you awake at night (highest priority)
    func error(_ string: String)
}
