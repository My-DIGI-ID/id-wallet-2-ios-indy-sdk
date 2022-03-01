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

/// JWE-container for a packed message.
///
/// This is actually a nested structure containing different information about the packing.
/// Since the information is processed with Base64, we leave this container at top level.
public struct PackedMessage: Decodable {
    private enum CodingKeys: String, CodingKey {
        case protected
        case iv
        case cipherText = "ciphertext"
        case tag
    }
    
    public let protected: String
    public let iv: String
    public let cipherText: String
    public let tag: String
}
