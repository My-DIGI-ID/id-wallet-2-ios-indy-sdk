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

import Foundation
import IndyObjc

/// Namespace for all encryption / decryption related operations.
public enum Crypto {
    /// Creates a new key pair and stores them in the wallet.
    ///
    /// - Parameter configuration: Configuration for the generation process.
    /// - Parameter wallet: Reference of the wallet for storing the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: Verkey of the generated key pair, also used as key identifier.
    /// - Throws: ``IndyError``
    public static func createKey(
        with configuration: KeyConfiguration = KeyConfiguration(),
        in wallet: IndyHandle
    ) async throws -> String {
        let configuration = try JSONEncoder.shared.string(configuration)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyCrypto.createKey(
                configuration,
                walletHandle: wallet,
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
    
    /// Saves or replaces the meta information for the given key in the wallet.
    ///
    /// - Parameter metadata: The metadata to be stored.
    /// - Parameter verkey: The verkey which the metadata is associated to.
    /// - Parameter wallet: Reference of the wallet where the keys are stored.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Throws: ``IndyError``
    public static func setMetadata(
        _ metatdata: String,
        for verkey: String,
        in wallet: IndyHandle
    ) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyCrypto.setMetadata(
                metatdata,
                forKey: verkey,
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
    
    /// Retrieves the meta information for the giving key in the wallet.
    ///
    /// - Parameter verkey: The verkey which the metadata is associated to.
    /// - Parameter wallet: Reference of the wallet where the keys are stored.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The metadata of the key pair.
    /// - Throws: ``IndyError``
    public static func getMetadata(
        for key: String,
        from wallet: IndyHandle
    ) async throws -> String {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.getMetadataForKey(
                key,
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
    
    /// Signs a message with a key.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// - Parameter message: The message to be signed.
    /// - Parameter key: The key identifier of the pair used for signing.
    /// - Parameter wallet: Reference of the wallet containing the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The signature string bytes.
    /// - Throws: ``IndyError``
    public static func sign(
        _ message: Data,
        with key: String,
        _ wallet: IndyHandle
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.signMessage(
                message,
                key: key,
                walletHandle: wallet,
                completion: { error, signature in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let signature = signature {
                        cont.resume(returning: signature)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Verify a signature with a verkey.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// - Parameter signature: The signature to be verified.
    /// - Parameter message: The message which has been signed.
    /// - Parameter key: Verkey of the signer.
    /// - Returns: True if the signature is valid, false otherwise.
    /// - Throws: ``IndyError``
    public static func verifiy(
        _ signature: Data,
        for message: Data,
        with key: String
    ) async throws -> Bool {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.verifySignature(
                signature,
                forMessage: message,
                key: key,
                completion: { error, isValid in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else {
                        cont.resume(returning: isValid)
                    }
                }
            )
        }
    }
    
    /// Encrypts a message by authenticated-encryption scheme.
    ///
    /// Sender can encrypt a confidential message specifically for Recipient, using Sender's public key.
    /// Using Recipient's public key, Sender can compute a shared secret key.
    /// Using Sender's public key and his secret key, Recipient can compute the exact same shared secret key.
    /// That shared secret key can be used to verify that the encrypted message was not tampered with,
    /// before eventually decrypting it.
    /// Recipient only needs Sender's public key, the nonce and the ciphertext to peform decryption.
    /// The nonce doesn't have to be confidential.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// - Parameter message: The message to be encrypted.
    /// - Parameter myKey: The verkey of the sender (you).
    /// - Parameter theirKey: The verkey of the receiver.
    /// - Parameter wallet: Reference of the wallet containing the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The encrypted message as an array of bytes.
    /// - Warning: myKey must be created by calling ``createKey(with:in:)``
    /// or ``Did/createAndStore(my:in:)``
    /// - Warning: This function is deprecated, use ``pack(_:for:from:with:)``.
    /// - Throws: ``IndyError``
    public static func authCrypt(
        _ message: Data,
        my myKey: String,
        their theirKey: String,
        with wallet: IndyHandle
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.authCrypt(
                message,
                myKey: myKey,
                theirKey: theirKey,
                walletHandle: wallet,
                completion: { error, encrypted in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let encrypted = encrypted {
                        cont.resume(returning: encrypted)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Decrypt a message by authenticated-encryption scheme.
    ///
    /// Sender can encrypt a confidential message specifically for Recipient, using Sender's public key.
    /// Using Recipient's public key, Sender can compute a shared secret key.
    /// Using Sender's public key and his secret key, Recipient can compute the exact same shared secret key.
    /// That shared secret key can be used to verify that the encrypted message was not tampered with,
    /// before eventually decrypting it.
    /// Recipient only needs Sender's public key, the nonce and the ciphertext to peform decryption.
    /// The nonce doesn't have to be confidential.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// - Parameter message: The message to be encrypted.
    /// - Parameter key: The verkey of the receiver (you).
    /// - Parameter wallet: Reference of the wallet containing the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The verkey of the sender and the decrypted message.
    /// - Warning: key must be created by calling ``createKey(with:in:)``
    /// or ``Did/createAndStore(my:in:)``
    /// - Warning: This function is deprecated, use ``unpack(_:with:)``.
    /// - Throws: ``IndyError``
    public static func authDecrypt(
        _ message: Data,
        with key: String,
        in wallet: IndyHandle
    ) async throws -> (String, Data) {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.authDecrypt(
                message,
                myKey: key,
                walletHandle: wallet,
                completion: { error, verkey, decrypted in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let verkey = verkey, let decrypted = decrypted {
                        cont.resume(returning: (verkey, decrypted))
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Encrypts a message by anonymous-encryption scheme.
    ///
    /// Sealed boxes are designed to anonymously send messages to a Recipient given its public key.
    /// Only the Recipient can decrypt these messages, using its private key.
    /// While the Recipient can verify the integrity of the message, it cannot verify the identity of the Sender.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// Use ``pack(_:for:from:with:)`` function for A2A goals.
    ///
    /// - Parameter message: The message to be encrypted.
    /// - Parameter key: The verkey of the receiver.
    /// - Returns: The encrypted message as an array of bytes.
    /// - Throws: ``IndyError``
    public static func anonCrypt(
        _ message: Data,
        with key: String
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.anonCrypt(
                message,
                theirKey: key,
                completion: { error, encrypted in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let encrypted = encrypted {
                        cont.resume(returning: encrypted)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Decrypts a message by anonymous-encryption scheme.
    ///
    /// Sealed boxes are designed to anonymously send messages to a Recipient given its public key.
    /// Only the Recipient can decrypt these messages, using its private key.
    /// While the Recipient can verify the integrity of the message, it cannot verify the identity of the Sender.
    ///
    /// In order to use DID keys with this function, you can call ``Did/key(for:in:_:)`` to get the verkey for a specific DID.
    ///
    /// Use ``unpack(_:with:)`` function for A2A goals.
    ///
    /// - Parameter message: The message to be decrypted.
    /// - Parameter key: The verkey of the receiver (you).
    /// - Parameter wallet: Reference of the wallet containing the keys.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The decrypted message as an array of bytes.
    /// - Throws: ``IndyError``
    public static func anonDecrypt(
        _ message: Data,
        with key: String,
        in wallet: IndyHandle
    ) async throws -> Data {
        try await withCheckedThrowingContinuation { cont in
            IndyCrypto.anonDecrypt(
                message,
                myKey: key,
                walletHandle: wallet,
                completion: { error, decrypted in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let decrypted = decrypted {
                        cont.resume(returning: decrypted)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Packs a message by encrypting the message and serializes it in a JWE-like format.
    ///
    /// - Parameter message: The message to be packed.
    /// - Parameter receivers: The verkeys of the receivers of this message.
    /// - Parameter sender: The verkey of the sender.
    /// - Parameter wallet: The reference to wallet used for packing.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The encrypted message as bytes.
    /// - Warning: This is an experimental function.
    /// - Throws: ``IndyError``
    public static func pack<T: Encodable>(
        _ message: T,
        for receivers: [String],
        from sender: String? = nil,
        with wallet: IndyHandle
    ) async throws -> Data {
        let message = try JSONEncoder.shared.encode(message)
        let receivers = try JSONEncoder.shared.string(receivers)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyCrypto.packMessage(
                message,
                receivers: receivers,
                sender: sender,
                walletHandle: wallet,
                completion: { error, packed in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let packed = packed {
                        cont.resume(returning: packed)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
    }
    
    /// Packs a message by encrypting the message and serializes it in a JWE-like format.
    ///
    /// - Parameter message: The message to be packed.
    /// - Parameter receivers: The verkeys of the receivers of this message.
    /// - Parameter sender: The verkey of the sender.
    /// - Parameter wallet: The reference to wallet used for packing.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: The container for the packed message.
    /// - Warning: This is an experimental function.
    /// - Throws: ``IndyError``
    public static func pack<T: Encodable>(
        _ message: T,
        for receivers: [String],
        from sender: String? = nil,
        with wallet: IndyHandle
    ) async throws -> PackedMessage {
        let result: Data = try await pack(
            message, for: receivers, from: sender, with: wallet
        )
        
        return try JSONDecoder.shared.decode(PackedMessage.self, from: result)
    }
    
    /// Unpacks a JWE-like formatted message outputted by ``pack(_:for:from:with:)``.
    ///
    /// - Parameter message: The JWE to be unpacked.
    /// - Parameter wallet: Reference of the wallet used for unpacking.
    /// Can be obtained by ``Wallet/open(with:_:)``.
    /// - Returns: Unpacked message container.
    /// - Throws: ``IndyError``
    public static func unpack<T: Decodable>(
        _ message: Data,
        with wallet: IndyHandle
    ) async throws -> UnpackedMessage<T> {
        let unpacked: Data = try await withCheckedThrowingContinuation { cont in
            IndyCrypto.unpackMessage(
                message,
                walletHandle: wallet,
                completion: { error, unpacked in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else if let unpacked = unpacked {
                        cont.resume(returning: unpacked)
                    } else {
                        cont.resume(throwing: IndyError.invalidState)
                    }
                }
            )
        }
        
        return try JSONDecoder.shared.decode(UnpackedMessage<T>.self, from: unpacked)
    }
}
