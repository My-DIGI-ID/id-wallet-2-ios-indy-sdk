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

final class SearchItemTests: XCTestCase {
    func test_decode() throws {
        // Arrange
        let expected = SearchItem(
            id: "id",
            type: nil,
            value: nil,
            tags: nil
        )
        let json = try loadJson("SearchItem")
        
        // Act
        let actual: SearchItem = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.id, expected.id)
        XCTAssertEqual(actual.type, expected.type)
        XCTAssertEqual(actual.value, expected.value)
        XCTAssertEqual(actual.tags, expected.tags)
    }
    
    func test_decode_full() throws {
        // Arrange
        let expected = SearchItem(
            id: "id",
            type: "type",
            value: "value",
            tags: [
                "tagName": "tagValue"
            ]
        )
        let json = try loadJson("SearchItemFull")
        
        // Act
        let actual: SearchItem = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.id, expected.id)
        XCTAssertEqual(actual.type, expected.type)
        XCTAssertEqual(actual.value, expected.value)
        XCTAssertEqual(actual.tags, expected.tags)
    }
}
