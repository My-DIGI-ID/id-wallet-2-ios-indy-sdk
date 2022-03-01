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

/// Namespace for all record related operations.
public enum NonSecrets {
    /// Create a new non-secret record in the wallet.
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be added.
    /// Can be obtained with ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter value: Content of the record.
    /// - Parameter tags: The record tags used for search and storing meta information.
    /// - Warning: Unencrypted tags need a key prefixed with "~".
    /// This enables full filtering, while encrypted ones only support exact matching.
    /// - Throws: ``IndyError``
    public static func addRecord(
        to wallet: IndyHandle,
        type: String,
        id: String,
        value: String,
        tags: [String: String] = [:]
    ) async throws {
        let tags = try JSONEncoder.shared.string(tags)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.addRecord(
                inWallet: wallet,
                type: type,
                id: id,
                value: value,
                tagsJson: tags,
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
    
    /// Update a non-secret wallet record value.
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be updated.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter value: Content of the record.
    /// - Throws: ``IndyError``
    public static func updateRecordValue(
        in wallet: IndyHandle,
        type: String,
        id: String,
        value: String
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.updateRecordValue(
                inWallet: wallet,
                type: type,
                id: id,
                value: value,
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
    
    /// Update a non-secret wallet record tags.
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be updated.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter tags: The record tags used for search and storing meta information.
    /// - Warning: Unencrypted tags need a key prefixed with "~".
    /// This enables full filtering, while encrypted ones only support exact matching.
    /// - Throws: ``IndyError``
    public static func updateRecordTags(
        in wallet: IndyHandle,
        type: String,
        id: String,
        tags: [String: String]
    ) async throws {
        let tags = try JSONEncoder.shared.string(tags)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.updateRecordTags(
                inWallet: wallet,
                type: type,
                id: id,
                tagsJson: tags,
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
    
    /// Add new tags to the wallet record.
    ///
    /// - Parameter wallet: Reference of the wallet where the record tags should be added.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter tags: The record tags used for search and storing meta information.
    /// - Warning: Unencrypted tags need a key prefixed with "~".
    /// This enables full filtering, while encrypted ones only support exact matching.
    /// - Throws: ``IndyError``
    public static func addRecordTags(
        in wallet: IndyHandle,
        type: String,
        id: String,
        tags: [String: String]
    ) async throws {
        let tags = try JSONEncoder.shared.string(tags)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.addRecordTags(
                inWallet: wallet,
                type: type,
                id: id,
                tagsJson: tags,
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
    
    /// Delete tags from the wallet record.
    ///
    /// - Parameter wallet: Reference of the wallet where the record tags should be deleted.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter tags: The names of the tags to be deleted.
    /// - Warning: Unencrypted tags need a key prefixed with "~".
    /// This enables full filtering, while encrypted ones only support exact matching.
    /// - Throws: ``IndyError``
    public static func deleteRecordTags(
        in wallet: IndyHandle,
        type: String,
        id: String,
        tags: [String]
    ) async throws {
        let tags = try JSONEncoder.shared.string(tags)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.deleteRecordTags(
                inWallet: wallet,
                type: type,
                id: id,
                tagsNames: tags,
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
    
    /// Delete an existing wallet record in the wallet.
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be deleted.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Throws: ``IndyError``
    public static func deleteRecord(
        to wallet: IndyHandle,
        type: String,
        id: String
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.deleteRecord(
                inWallet: wallet,
                type: type,
                id: id,
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
    
    /// Get an wallet record by id
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be retrieved.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter options: Defines which part of the data should be retrieved
    /// - Returns: The item containing the requested data for specified record.
    /// - Throws: ``IndyError``
    public static func getRecord(
        from wallet: IndyHandle,
        type: String,
        id: String,
        options: SearchOptions
    ) async throws -> SearchItem {
        let options = try JSONEncoder.shared.string(options)
        
        let encoded: String = try await withCheckedThrowingContinuation { cont in
            IndyNonSecrets.getRecordFromWallet(
                wallet,
                type: type,
                id: id,
                optionsJson: options,
                completion: { error, result in
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
        
        return try JSONDecoder.shared.model(encoded)
    }
    
    /// Start search for wallet records.
    ///
    /// This call only opens a search so results can be fetched in small batches and finally closed.
    ///
    /// - Parameter wallet: Reference of the wallet where the record should be added.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter type: Type allows to separate records into different collections.
    /// - Parameter id: Unique identfier of the record.
    /// - Parameter query: Defines the applied search filter.
    /// - Parameter options: Defines which part of the data should be retrieved.
    /// - Returns: Reference to the opened search. It needs to be used in
    /// ``continue(search:in:count:)`` and ``close(search:)``.
    /// - Throws: ``IndyError``
    public static func search(
        in wallet: IndyHandle,
        type: String,
        query: SearchQuery = .none,
        options: SearchOptions
    ) async throws -> IndyHandle {
        let query = try JSONEncoder.shared.string(query)
        let options = try JSONEncoder.shared.string(options)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyNonSecrets.openSearch(
                inWallet: wallet,
                type: type,
                queryJson: query,
                optionsJson: options,
                completion: { error, handle in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else {
                        cont.resume(returning: handle)
                    }
                }
            )
        }
    }
    
    /// Create a new non-secret record in the wallet.
    ///
    /// - Parameter search: Reference to the search. Can be obtained by ``search(in:type:query:options:)``.
    /// - Parameter wallet: Reference of the wallet where the record should be added.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Parameter count: Count of records to fetch
    /// - Returns: Result containing the next valid records in the search.
    /// - Throws: ``IndyError``
    public static func `continue`(
        search: IndyHandle,
        in wallet: IndyHandle,
        count: Int
    ) async throws -> SearchResult {
        let encoded: String = try await withCheckedThrowingContinuation { cont in
            IndyNonSecrets.fetchNextRecords(
                fromSearch: search,
                walletHandle: wallet,
                count: count as NSNumber,
                completion: { error, result in
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
        
        return try JSONDecoder.shared.model(encoded)
    }
    
    /// Closes an open search.
    ///
    /// - Parameter search: Reference to the search. Can be obtained by ``search(in:type:query:options:)``.
    /// - Throws: ``IndyError``
    public static func close(
        search: IndyHandle
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyNonSecrets.closeSearch(
                withHandle: search,
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
