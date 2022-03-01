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

public struct OpenPoolConfiguration: Encodable {
    private enum CodingKeys: String, CodingKey {
        case timeout
        case timeoutExtended = "extended_timeout"
        case order = "preordered_nodes"
        case count = "number_read_nodes"
    }
    
    public var timeout: Int?
    public var timeoutExtended: Int?
    public var order: [String]?
    public var count: Int?
    
    public init() {}
}
