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

// swiftlint:disable discouraged_optional_boolean

/// Container for all identity information related to DIDs.
public struct DidIdentity: Encodable {
    private enum CodingKeys: String, CodingKey {
        case did
        case verkey
        case seed
        case type = "crypto_type"
        case cid
        case method = "method_name"
    }
    
    public let did: String?
    public let verkey: String?
    public let seed: String?
    public let type: CryptoType?
    public let cid: Bool?
    public let method: String?
    
    /// Create identity information for your own local DID.
    public static func creation(
        did: String? = nil,
        seed: String? = nil,
        type: CryptoType = .ed25519,
        cid: Bool = false,
        method: String? = nil
    ) -> DidIdentity {
        DidIdentity(
            did: did,
            verkey: nil,
            seed: seed,
            type: type,
            cid: cid,
            method: method
        )
    }
    
    /// Ceate identity information to update the keys of your local DID.
    public static func replacement(
        seed: String? = nil,
        type: CryptoType = .ed25519
    ) -> DidIdentity {
        DidIdentity(
            did: nil,
            verkey: nil,
            seed: seed,
            type: type,
            cid: nil,
            method: nil
        )
    }
    
    /// Ceate identity information to store a foreign DID.
    public static func foreign(
        did: String,
        verkey: String? = nil,
        type: CryptoType = .ed25519
    ) -> DidIdentity {
        DidIdentity(
            did: did,
            verkey: verkey,
            seed: nil,
            type: type,
            cid: nil,
            method: nil
        )
    }
}
