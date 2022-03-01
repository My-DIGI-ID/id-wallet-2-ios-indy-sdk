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

import IndyObjc
import Darwin

public enum Ledger {
    public static func submit(_ request: String, to pool: IndyHandle) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyLedger.submitRequest(
                request,
                poolHandle: pool,
                completion: { (error, result) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let result = result {
                        cont.resume(returning: result)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    public static func requestGetCredentialDefinition(for id: String, with did: String? = nil) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyLedger.buildGetCredDefRequest(
                withSubmitterDid: did,
                id: id,
                completion: { (error, request) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let request = request {
                        cont.resume(returning: request)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    public static func responseGetCredentialDefinition(_ result: String) async throws -> (String, String) {
        try await withCheckedThrowingContinuation { cont in
            IndyLedger.parseGetCredDefResponse(
                result,
                completion: { (error, id, definition) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let id = id, let definition = definition {
                        cont.resume(returning: (id, definition))
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    public static func requestGetRevocationRegistryDefinition(
        for id: String,
        with did: String? = nil
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyLedger.buildGetRevocRegDefRequest(
                withSubmitterDid: did,
                id: id,
                completion: { (error, request) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let request = request {
                        cont.resume(returning: request)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    public static func responseGetRevocationRegistryDefinition(_ result: String) async throws -> (String, String) {
        try await withCheckedThrowingContinuation { cont in
            IndyLedger.parseGetRevocRegDefResponse(
                result,
                completion: { (error, id, definition) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let id = id, let definition = definition {
                        cont.resume(returning: (id, definition))
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
}
