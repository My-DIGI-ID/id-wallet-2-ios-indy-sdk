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

/// This is dynamic structure to define complex search queries.
/// The filters are executed on the tags of the records.
public indirect enum SearchQuery {
    case none
    case and([SearchQuery])
    case or([SearchQuery])
    case not(SearchQuery)
    case equal(name: String, value: String)
    case unequal(name: String, value: String)
    case less(name: String, value: String)
    case lessEqual(name: String, value: String)
    case greater(name: String, value: String)
    case greaterEqual(name: String, value: String)
    case like(name: String, value: String)
    case `in`(name: String, value: [String])
}
