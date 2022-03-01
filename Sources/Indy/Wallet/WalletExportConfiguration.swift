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

/// All settings needed for the export process.
public struct WalletExportConfiguration: Encodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case key
        case derivationMethod = "key_derivation_method"
    }
    
    /// The path where the file should be exported that contains wallet content.
    public let path: String
    /// The key used for export of the wallet.
    public let key: String
    /// Algorithm to use for wallet export key derivation.
    public let derivationMethod: KeyDerivationMethod?
    
    public init(
        path: String,
        key: String,
        derivationMethod: KeyDerivationMethod? = nil
    ) {
        self.path = path
        self.key = key
        self.derivationMethod = derivationMethod
    }
}
