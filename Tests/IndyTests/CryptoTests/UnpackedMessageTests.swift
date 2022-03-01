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

final class UnpackedMessageTests: XCTestCase {
    func test_decode() throws {
        // Arrange
        let expected = UnpackedMessage(
            message: ["tag": "value"],
            keySender: nil,
            keyRecipient: "keyRecipient"
        )
        let json = try loadJson("UnpackedMessage")
        
        // Act
        let actual: UnpackedMessage<[String: String]> = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.message, expected.message)
        XCTAssertEqual(actual.keySender, expected.keySender)
        XCTAssertEqual(actual.keyRecipient, expected.keyRecipient)
    }
    
    func test_decode_full() throws {
        // Arrange
        let expected = UnpackedMessage(
            message: ["tag": "value"],
            keySender: "keySender",
            keyRecipient: "keyRecipient"
        )
        let json = try loadJson("UnpackedMessageFull")
        
        // Act
        let actual: UnpackedMessage<[String: String]> = try JSONDecoder.shared.model(json)
        
        // Asert
        XCTAssertEqual(actual.message, expected.message)
        XCTAssertEqual(actual.keySender, expected.keySender)
        XCTAssertEqual(actual.keyRecipient, expected.keyRecipient)
    }
}
