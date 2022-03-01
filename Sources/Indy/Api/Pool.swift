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

public enum Pool {
    public static func create(
        with name: String,
        _ configuration: PoolConfiguration = PoolConfiguration()
    ) async throws {
        let configuration = try JSONEncoder.shared.string(configuration)
        
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyPool.createPoolLedgerConfig(
                withPoolName: name,
                poolConfig: configuration,
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
    
    public static func delete(for name: String) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyPool.deleteLedgerConfig(
                withName: name,
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
    
    public static func open(
        with name: String,
        _ configuration: OpenPoolConfiguration = OpenPoolConfiguration()
    ) async throws -> IndyHandle {
        let configuration = try JSONEncoder.shared.string(configuration)
        
        return try await withCheckedThrowingContinuation { cont in
            IndyPool.openLedger(
                withName: name,
                poolConfig: configuration,
                completion: { (error, handle) in
                    if let error = error as NSError?, error.code != 0, let indyError = IndyError(rawValue: error.code) {
                        cont.resume(throwing: indyError)
                    } else {
                        cont.resume(returning: handle)
                    }
                }
            )
        }
    }
    
    public static func refresh(_ handle: IndyHandle) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyPool.refreshPoolLedger(
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
    
    public static func close(_ handle: IndyHandle) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyPool.closeLedger(
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
    
    public static func version(_ version: ProtocolVersion = .v1_3) async throws {
        try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Void, Error>) in
            IndyPool.setProtocolVersion(
                NSNumber(value: version.rawValue),
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

extension Pool {
    
    public static func create(
        with name: String,
        _ path: String? = nil
    ) async throws {
        try await create(with: name, PoolConfiguration(genesis: path))
    }
}
