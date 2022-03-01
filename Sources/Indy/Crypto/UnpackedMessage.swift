//
// Copyright 2022 Bundesrepublik Deutschland
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
// the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//

/// Container for an unpacked message and its used keys.
public struct UnpackedMessage<T: Decodable>: Decodable {
    private enum CodingKeys: String, CodingKey {
        case message
        case keySender = "sender_verkey"
        case keyRecipient = "recipient_verkey"
    }
    
    /// The unpacked message.
    public let message: T
    /// Key of the sender.
    public let keySender: String?
    /// Key of the receiver (your agent).
    public let keyRecipient: String
}
