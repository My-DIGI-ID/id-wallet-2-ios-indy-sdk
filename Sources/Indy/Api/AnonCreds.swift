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

// swiftlint:disable inclusive_language

import Foundation
import IndyObjc

/// All functionality for negotiating, issuing and proofing credentials.
///
/// It is split up in sub namespaces according to the roles acting in self-sovereign decentralized identity.
public enum AnonCreds {
    public enum Issuer {}
    public enum Verifier {}
    public enum Prover {
        public static func masterSecret(
            with id: String,
            in wallet: IndyHandle
        ) async throws -> String {
            try await withCheckedThrowingContinuation { cont in
                IndyAnoncreds.proverCreateMasterSecret(
                    id,
                    walletHandle: wallet,
                    completion: { (error, id) in
                        if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                            cont.resume(throwing: indyError)
                        } else if let id = id {
                            cont.resume(returning: id)
                        } else {
                            cont.resume(throwing: IndyError.invalidState)
                        }
                    }
                )
            }
        }
     
        public static func request(
            from offer: String,
            _ definition: String,
            _ proverDid: String,
            _ masterSecretId: String,
            _ wallet: IndyHandle
        ) async throws -> (String, String) {
            try await withCheckedThrowingContinuation { cont in
                IndyAnoncreds.proverCreateCredentialReq(
                    forCredentialOffer: offer,
                    credentialDefJSON: definition,
                    proverDID: proverDid,
                    masterSecretID: masterSecretId,
                    walletHandle: wallet,
                    completion: { (error, request, metadata) in
                        if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                            cont.resume(throwing: indyError)
                        } else if let request = request, let metadata = metadata {
                            cont.resume(returning: (request, metadata))
                        } else {
                            cont.resume(throwing: IndyError.invalidState)
                        }
                    }
                )
            }
        }
        
        public static func store(
            _ credential: String,
            for id: String? = nil,
            _ metadata: String,
            _ definition: String,
            _ revocationDefinition: String,
            _ wallet: IndyHandle
        ) async throws -> String {
            return try await withCheckedThrowingContinuation { cont in
                IndyAnoncreds.proverStoreCredential(
                    credential,
                    credID: id,
                    credReqMetadataJSON: metadata,
                    credDefJSON: definition,
                    revRegDefJSON: revocationDefinition,
                    walletHandle: wallet,
                    completion: { (error, id) in
                        if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                            cont.resume(throwing: indyError)
                        } else if let id = id {
                            cont.resume(returning: id)
                        } else {
                            cont.resume(throwing: IndyError.invalidState)
                        }
                    }
                )
            }
        }
        
        public static func get(for id: String, from wallet: IndyHandle) async throws -> Credential {
            let encoded: String = try await withCheckedThrowingContinuation { cont in
                IndyAnoncreds.proverGetCredential(
                    withId: id,
                    walletHandle: wallet,
                    completion: { (error, credential) in
                        if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                            cont.resume(throwing: indyError)
                        } else if let credential = credential {
                            cont.resume(returning: credential)
                        } else {
                            cont.resume(throwing: IndyError.invalidState)
                        }
                    }
                )
            }
            
            return try JSONDecoder.shared.model(encoded)
        }
        
        public static func delete(for id: String, in wallet: IndyHandle) async throws {
            try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
                IndyAnoncreds.proverDeleteCredentials(
                    withId: id,
                    walletHandle: wallet,
                    completion: { error in
                        if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                            cont.resume(throwing: indyError)
                        } else {
                            cont.resume()
                        }
                    }
                )
            }
        }
    }
}
