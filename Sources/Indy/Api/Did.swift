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

public enum Did {
    /// Creates keys (signing and encryption keys) for a new DID (owned by the caller of the library).
    ///
    /// Identity's DID must be either explicitly provided, or taken as the first 16 bit of verkey.
    /// Saves the Identity DID with keys in a secured Wallet, so that it can be used to sign
    /// and encrypt transactions.
    ///
    /// - Parameter did: Identity used for did creation
    /// - Parameter wallet: Reference of the wallet for storing the DID.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The created DID and the corresponding verkey.
    /// - Throws: ``IndyError``
    public static func createAndStore(
        my did: DidIdentity = .creation(),
        in wallet: IndyHandle
    ) async throws -> (String, String) {
        let did = try JSONEncoder.shared.string(did)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyDid.createAndStoreMyDid(
                did,
                walletHandle: wallet,
                completion: { error, did, verkey in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let did = did, let verkey = verkey {
                        cont.resume(returning: (did, verkey))
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Generated temporary keys (signing and encryption keys) for an existing
    /// DID (owned by the caller of the library).
    ///
    /// - Parameter did: Your existing DID.
    /// - Parameter identity: The identity information needed to update the keys.
    /// - Parameter wallet: Reference of the wallet for updating the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The new verkey.
    /// - Throws: ``IndyError``
    public static func replaceKeysStart(
        for did: String,
        with identity: DidIdentity = .replacement(),
        in wallet: IndyHandle
    ) async throws -> String {
        let identity = try JSONEncoder.shared.string(identity)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyDid.replaceKeysStart(
                forDid: did,
                identityJson: identity,
                walletHandle: wallet,
                completion: { error, verkey in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let verkey = verkey {
                        cont.resume(returning: verkey)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Apply temporary keys as main for an existing DID (owned by the caller of the library).
    ///
    /// - Parameter did: The DID whose keys should be replaced.
    /// - Parameter wallet: Reference of the wallet for updating the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Throws: ``IndyError``
    public static func replaceKeysApply(
        for did: String,
        in wallet: IndyHandle
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyDid.replaceKeysApply(
                forDid: did,
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
    
    /// Saves their DID for a pairwise connection in a secured Wallet, so that it can be used to verify transaction.
    ///
    /// Updates DID associated verkey in case DID already exists in the Wallet.
    ///
    /// - Parameter identity: Identity information needed to store the DID.
    /// - Parameter wallet: Reference of the wallet for storing the DID.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Throws: ``IndyError``
    public static func storeTheirDid(
        with identity: DidIdentity,
        in wallet: IndyHandle
    ) async throws {
        let identity = try JSONEncoder.shared.string(identity)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyDid.storeTheirDid(
                identity,
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
    
    /// Short version of ``storeTheirDid(with:in:)`` for only storing the DID.
    public static func storeTheirDid(
        _ did: String,
        in wallet: IndyHandle
    ) async throws {
        try await storeTheirDid(with: .foreign(did: did), in: wallet)
    }
    
    /// Returns verkey for the given DID.
    ///
    /// This functions follows the idea that we resolve information about their DID from
    /// the ledger with cache in the local wallet. The "openWallet" call has freshness parameter
    /// that is used for checking the freshness of cached pool value.
    ///
    /// If you don't want to resolve their DID info from the ledger you can use
    /// ``key(forLocal:in:)`` call instead that will look only to local wallet and skip
    /// freshness checking.
    ///
    /// Note that ``createAndStore(my:in:)`` makes similar wallet record as
    /// ``Crypto/createKey(with:in:)``. As result we can use returned verkey
    /// in all generic crypto and messaging functions.
    ///
    /// - Parameter did: The did of the requested verkey.
    /// - Parameter pool: Reference of the pool for retrieving the key.
    /// - Parameter wallet: Reference of the wallet for retrieving the key.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The verkey of the DID.
    /// - Throws: ``IndyError``
    public static func key(
        for did: String,
        in pool: IndyHandle,
        _ wallet: IndyHandle
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.key(
                forDid: did,
                poolHandle: pool,
                walletHandle: wallet,
                completion: { error, did in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let did = did {
                        cont.resume(returning: did)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Returns verkey for the given DID.
    ///
    /// This call looks data stored in the local wallet only and skips freshness checking.
    ///
    /// If you want to get fresh data from the ledger you can use ``key(for:in:_:)`` call instead.
    ///
    /// Note that ``createAndStore(my:in:)`` makes similar wallet record as
    /// ``Crypto/createKey(with:in:)``. As result we can use returned verkey
    /// in all generic crypto and messaging functions.
    ///
    /// - Parameter did: The did of the requested verkey.
    /// - Parameter wallet: Reference of the wallet for retrieving the key.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The verkey of the DID.
    /// - Throws: ``IndyError``
    public static func key(
        forLocal did: String,
        in wallet: IndyHandle
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.key(
                forLocalDid: did,
                walletHandle: wallet,
                completion: { error, did in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let did = did {
                        cont.resume(returning: did)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Set/replaces endpoint information for the given DID.
    ///
    /// - Parameter address: The endpoint address.
    /// - Parameter key: The transport key of the endpoint.
    /// - Parameter did: The DID which should resolve to the endpoint.
    /// - Parameter wallet: Reference of the wallet for storing the endpoint information.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The verkey of the DID.
    /// - Throws: ``IndyError``
    public static func setEndpoint(
        to address: String,
        _ key: String,
        for did: String,
        in wallet: IndyHandle
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyDid.setEndpointAddress(
                address,
                transportKey: key,
                forDid: did,
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
    
    /// Returns endpoint information for the given DID.
    ///
    /// - Parameter did: The DID the endpoint is associated to.
    /// - Parameter wallet: Reference of the wallet for retrieving the adress and key.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter pool: Reference of the pool to resolve the endpoint information.
    /// - Returns: The address and transport key.
    /// - Throws: ``IndyError``
    public static func getEndpoint(
        for did: String,
        from wallet: IndyHandle,
        _ pool: IndyHandle
    ) async throws -> (String, String) {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.getEndpointForDid(
                did,
                walletHandle: wallet,
                poolHandle: pool,
                completion: { error, address, key in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let address = address, let key = key {
                        cont.resume(returning: (address, key))
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Saves/replaces the meta information for the giving DID in the wallet.
    ///
    /// - Parameter metadata: The metadata to be stored.
    /// - Parameter did: The DID the metadata should be associated with.
    /// - Parameter wallet: Reference of the wallet for retrieving the adress and key.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Throws: ``IndyError``
    public static func setMetadata(
        _ metadata: String,
        for did: String,
        in wallet: IndyHandle
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyDid.setMetadata(
                metadata,
                forDid: did,
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
    
    /// Retrieves the meta information for the giving DID in the wallet.
    ///
    /// - Parameter did: The DID that resolves to the metadata.
    /// - Parameter wallet: Reference of the wallet for retrieving the adress and key.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The metadata
    /// - Throws: ``IndyError``
    public static func getMetadata(
        for did: String,
        from wallet: IndyHandle
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.getMetadataForDid(
                did,
                walletHandle: wallet,
                completion: { error, metadata in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let metadata = metadata {
                        cont.resume(returning: metadata)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Retrieves abbreviated verkey if it is possible otherwise return full verkey.
    ///
    /// - Parameter did: The DID of the verkey.
    /// - Parameter verkey: The full verkey.
    /// - Returns: The DIDs verkey in either abbreviated or full form.
    /// - Throws: ``IndyError``
    public static func abbreviateVerkey(
        for did: String,
        with verkey: String
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.abbreviateVerkey(
                did,
                fullVerkey: verkey,
                completion: { error, verkey in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let verkey = verkey {
                        cont.resume(returning: verkey)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Retrieves the information about all DIDs stored in the wallet.
    ///
    /// - Parameter wallet: Reference of the wallet containing the DIDs.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: List of all DIDs with their metadata.
    /// - Throws: ``IndyError``
    public static func listMyDidsWithMetadata(
        in wallet: IndyHandle
    ) async throws -> [DidContainer] {
        let encoded: String = try await withCheckedThrowingContinuation { cont in
            IndyDid.listMyDids(
                withMeta: wallet,
                completion: { error, dids in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let dids = dids {
                        cont.resume(returning: dids)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
        
        return try JSONDecoder.shared.model(encoded)
    }
    
    /// Update DID stored in the wallet to make fully qualified, or to do other DID maintenance.
    ///
    /// If the DID has no prefix, a prefix will be appended (prepend did:peer to a legacy did)
    /// If the DID has a prefix, a prefix will be updated (migrate did:peer to did:peer-new)
    ///
    /// Updates DID related entities stored in the wallet.
    ///
    /// - Parameter did: The DID to qualify.
    /// - Parameter method: The method to apply to the DID.
    /// - Parameter wallet: Reference of the wallet containing the DID.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The fully qualified DID.
    /// - Throws: ``IndyError``
    public static func qualifyDid(
        _ did: String,
        with method: String,
        in wallet: IndyHandle
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyDid.qualifyDid(
                did,
                method: method,
                walletHandle: wallet,
                completion: { error, dids in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let dids = dids {
                        cont.resume(returning: dids)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
}
