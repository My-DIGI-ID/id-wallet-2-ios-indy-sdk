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

/// All settings needed for the import process.
public struct WalletImportConfiguration: Encodable {
    /// The path of the file that contains exported wallet content.
    public let path: String
    /// The key used for export of the wallet.
    public let key: String
    
    public init(
        path: String,
        key: String
    ) {
        self.path = path
        self.key = key
    }
}
