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

import Foundation

/// An issued credential
public struct Credential: Codable {
    private enum CodingKeys: String, CodingKey {
        case id = "referent"
        case attributes = "attrs"
        case schema = "schema_id"
        case definition = "cred_def_id"
        case registry = "rev_reg_id"
        case revocation = "cred_rev_id"
    }
    
    /// Identifier of the credential
    public let id: String
    /// Key-Value pairs of information for presentation
    public let attributes: [String: String]
    /// Identifier of the schema
    public let schema: String
    /// Identifier of the credential definition
    public let definition: String
    /// Identifier of the revocation registry definition
    public let registry: String?
    /// Identifier of the credential in the revocation registry definition
    public let revocation: String?
}
