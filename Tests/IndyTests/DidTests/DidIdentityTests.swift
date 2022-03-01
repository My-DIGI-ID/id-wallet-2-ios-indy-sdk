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

final class DidIdentityTests: XCTestCase {
    func test_encode() throws {
        // Arrange
        let identity = DidIdentity(
            did: nil,
            verkey: nil,
            seed: nil,
            type: nil,
            cid: nil,
            method: nil
        )
        let expected = try loadJson("DidIdentity")
        
        // Act
        let actual = try JSONEncoder.shared.string(identity)
        
        // Assert
        XCTAssertEqual(actual, expected)
    }
    
    func test_encode_creation() throws {
        // Arrange
        let identity = DidIdentity.creation(
            did: "did",
            seed: "seed",
            type: .ed25519,
            cid: false,
            method: "method_name"
        )
        let expected = try loadJson("DidIdentityCreation")
        
        // Act
        let actual = try JSONEncoder.shared.string(identity)
        
        // Assert
        XCTAssertEqual(actual, expected)
    }
    
    func test_encode_replacement() throws {
        // Arrange
        let identity = DidIdentity.replacement(
            seed: "seed",
            type: .ed25519
        )
        let expected = try loadJson("DidIdentityReplacement")
        
        // Act
        let actual = try JSONEncoder.shared.string(identity)
        
        // Assert
        XCTAssertEqual(actual, expected)
    }
    
    func test_encode_foreign() throws {
        // Arrange
        let identity = DidIdentity.foreign(
            did: "did",
            verkey: "verkey",
            type: .ed25519
        )
        let expected = try loadJson("DidIdentityForeign")
        
        // Act
        let actual = try JSONEncoder.shared.string(identity)
        
        // Assert
        XCTAssertEqual(actual, expected)
    }
    
    func test_encode_full() throws {
        // Arrange
        let identity = DidIdentity(
            did: "did",
            verkey: "verkey",
            seed: "seed",
            type: .ed25519,
            cid: false,
            method: "method_name"
        )
        let expected = try loadJson("DidIdentityFull")
        
        // Act
        let actual = try JSONEncoder.shared.string(identity)
        
        // Assert
        XCTAssertEqual(actual, expected)
    }
}
