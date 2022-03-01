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

final class PackedMessageTests: XCTestCase {
    func test_decode() throws {
        // Arrange
        let expected = PackedMessage(
            protected: "protected",
            iv: "iv",
            cipherText: "cipherText",
            tag: "tag"
        )
        let json = try loadJson("PackedMessage")
        
        // Act
        let actual: PackedMessage = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.protected, expected.protected)
        XCTAssertEqual(actual.iv, expected.iv)
        XCTAssertEqual(actual.cipherText, expected.cipherText)
        XCTAssertEqual(actual.tag, expected.tag)
    }
}
