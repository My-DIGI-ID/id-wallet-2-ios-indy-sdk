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

@testable import Indy
import XCTest

final class SearchResultTests: XCTestCase {
    func test_decode() throws {
        // Arrange
        let expected = SearchResult(
            count: nil,
            records: nil
        )
        let json = try loadJson("SearchResult")
        
        // Act
        let actual: SearchResult = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.count, expected.count)
        XCTAssertEqual(actual.records?.count, expected.records?.count)
        XCTAssertNil(actual.records)
    }
    
    func test_decode_full() throws {
        // Arrange
        let expected = SearchResult(
            count: 1,
            records: [
                SearchItem(
                    id: "id",
                    type: "type",
                    value: "value",
                    tags: [
                        "tagName": "tagValue"
                    ]
                )
            ]
        )
        let json = try loadJson("SearchResultFull")
        
        // Act
        let actual: SearchResult = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.count, expected.count)
        XCTAssertEqual(actual.records?.count, expected.records?.count)
        XCTAssertNotNil(actual.records)
        
        for (i, actualItem) in (actual.records ?? []).enumerated() {
            guard let expectedItem = expected.records?[i] else { continue }
            
            XCTAssertEqual(actualItem.id, expectedItem.id)
            XCTAssertEqual(actualItem.type, expectedItem.type)
            XCTAssertEqual(actualItem.value, expectedItem.value)
            XCTAssertEqual(actualItem.tags, expectedItem.tags)
        }
    }
}
