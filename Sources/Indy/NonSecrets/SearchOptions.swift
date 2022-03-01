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

/// These options which part of the data should be retrieved from the wallet.
public struct SearchOptions: Encodable {
    private enum CodingKeys: String, CodingKey {
        case records = "retrieveRecords"
        case count = "retrieveTotalCount"
        case type = "retrieveType"
        case value = "retrieveValue"
        case tags = "retrieveTags"
    }
    
    /// Include the actual records. Only used in search.
    public let records: Bool
    /// Include the amount records. Only used in search.
    public let count: Bool
    /// Include the containing collection.
    public let type: Bool
    /// Include the content of the record.
    public let value: Bool
    /// INclude the tags of the record.
    public let tags: Bool
    
    public init(
        records: Bool,
        count: Bool,
        type: Bool,
        value: Bool,
        tags: Bool
    ) {
        self.records = records
        self.count = count
        self.type = type
        self.value = value
        self.tags = tags
    }
}
