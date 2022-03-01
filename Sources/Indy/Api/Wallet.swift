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

/// Namespace for all wallet related operations.
public enum Wallet {
    /// Creates a new secure wallet with the given unique name.
    ///
    /// - Parameter configuration: Configuration for the wallet.
    /// - Parameter credentials: Credentials used to access the wallet.
    /// - Throws: ``IndyError``
    public static func create(
        with configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws {
        let configuration = try JSONEncoder.shared.string(configuration)
        let credentials = try JSONEncoder.shared.string(credentials)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyWallet.sharedInstance().createWallet(
                withConfig: configuration,
                credentials: credentials,
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
    
    /// Opens the wallet with specific name.
    ///
    /// - Parameter configuration: Configuration for the wallet.
    /// - Parameter credentials: Credentials used to access the wallet.
    /// - Returns: A reference to the wallet.
    /// - Warning: Wallet with corresponded name must be previously created
    /// with ``create(with:_:)`` method.
    /// - Warning: It is impossible to open wallet with the same name more than once.
    /// - Throws: ``IndyError``
    public static func open(
        with configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws -> IndyHandle {
        let configuration = try JSONEncoder.shared.string(configuration)
        let credentials = try JSONEncoder.shared.string(credentials)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyWallet.sharedInstance().open(
                withConfig: configuration,
                credentials: credentials,
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
    
    /// Closes opened wallet and frees allocated resources.
    ///
    /// - Parameter handle: Reference to the wallet returned by ``open(with:_:)``.
    /// - Throws: ``IndyError``
    public static func close(for handle: IndyHandle) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyWallet.sharedInstance().close(
                withHandle: handle,
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
    
    /// Deletes created wallet. Wallet must be closed before deletion.
    ///
    /// - Parameter configuration: Configuration for the wallet.
    ///	- Parameter credentials: Credentials used to access the wallet.
    ///	- Throws: ``IndyError``
    public static func delete(
        with configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws {
        let configuration = try JSONEncoder.shared.string(configuration)
        let credentials = try JSONEncoder.shared.string(credentials)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyWallet.sharedInstance().delete(
                withConfig: configuration,
                credentials: credentials,
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
    
    /// Exports opened wallet.
    ///
    /// - Parameter handle: Reference to the wallet returned by ``open(with:_:)``.
    /// - Parameter configuration: Credentials used to access the wallet.
    /// - Throws: ``IndyError``
    public static func export(
        from handle: IndyHandle,
        with configuration: WalletExportConfiguration
    ) async throws {
        let configuration = try JSONEncoder.shared.string(configuration)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyWallet.sharedInstance().export(
                withHandle: handle,
                exportConfigJson: configuration,
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
    
    /// Creates a new secure wallet with the given unique name and then imports its content
    /// according to fields provided in importConfiguration.
    ///
    /// This can be seen as an ``create(with:_:)`` call with additional content import.
    ///
    /// - Parameter configuration: Configuration for the wallet.
    /// - Parameter credentials: Credentials used to access the wallet.
    /// - Parameter importConfiguration: Configuration for the import process.
    /// - Throws: ``IndyError``
    public static func `import`(
        with configuration: WalletConfiguration,
        _ credentials: WalletCredentials,
        _ importConfiguration: WalletImportConfiguration
    ) async throws {
        let configuration = try JSONEncoder.shared.string(configuration)
        let credentials = try JSONEncoder.shared.string(credentials)
        let importconfiguration = try JSONEncoder.shared.string(importConfiguration)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyWallet.sharedInstance().import(
                withConfig: configuration,
                credentials: credentials,
                importConfigJson: importconfiguration,
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
    
    /// Generate wallet master key.
    ///
    /// Returned key is compatible with ``KeyDerivationMethod/raw``.
    /// It allows to avoid expensive key derivation for use cases when wallet keys can be stored in a secure enclave.
    ///
    /// - Parameter configuration: Configuration for the wallet.
    /// - Returns: The generated key.
    /// - Throws: ``IndyError``
    public static func generateKey(seed: String? = nil) async throws -> String {
        let configuration: String?
        if let seed = seed {
            configuration = try JSONEncoder.shared.string(["seed": seed])
        } else {
            configuration = nil
        }
        
        return try await withCheckedThrowingContinuation { cont in
            IndyWallet.generateKey(
                forConfig: configuration,
                completion: { error, key in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let key = key {
                        cont.resume(returning: key)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
}
