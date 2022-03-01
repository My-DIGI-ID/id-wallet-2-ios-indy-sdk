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

public enum IndyError: Int, Error {
    // Common
    case invalidParameter1 = 100
    case invalidParameter2 = 101
    case invalidParameter3 = 102
    case invalidParameter4 = 103
    case invalidParameter5 = 104
    case invalidParameter6 = 105
    case invalidParameter7 = 106
    case invalidParameter8 = 107
    case invalidParameter9 = 108
    case invalidParameter10 = 109
    case invalidParameter11 = 110
    case invalidParameter12 = 111
    case invalidParameter13 = 115
    case invalidParameter14 = 116
    
    /// Signals Bug
    case invalidInternalState = 112
    case invalidStructure = 113
    case io = 114
    
    // Wallet
    case walletInvalidHandle = 200
    case walletUnknownType = 201
    case walletTypeAlreadyRegistered = 202
    case walletAlreadyExists = 203
    case walletNotFound = 204
    case walletIncompatiblePool = 205
    case walletAlreadyOpened = 206
    case walletAccessFailed = 207
    case walletInputInvalid = 208
    case walletDecoding = 209
    case walletStorage = 210
    case walletEncryption = 211
    case walletItemNotFound = 212
    case walletItemAlreadyExists = 213
    case walletQueryError = 214
    
    // Pool
    case poolLedgerNotCreated = 300
    case poolInvalidHandle = 301
    case poolTerminated = 302
    case poolNoConsensus = 303
    case poolInvalidTransaction = 304
    case poolSecurity = 305
    case poolConfigAlreadyExists = 306
    case poolTimeout = 307
    case poolIncompatibleProtocol = 308
    case poolNotFound = 309
    
    // AnonCreds
    case anonCredsRevocationRegistryFull = 400
    case anonCredsInvalidUserRecovation = 401
    case anonCredsAccumulatorIsFull = 402
    // swiftlint:disable inclusive_language
    case anonCredsMasterSecretDuplicateName = 404
    case anonCredsProofRejected = 405
    case anonCredsCredentialRevoked = 406
    case anonCredsDefinitionAlreadyExists = 407
    
    // Crypto
    case cryptoUnknownType = 500
    
    // DID
    case didAlreadyExists = 600
    
    // Payment
    case paymentMethodUnknown = 700
    case paymentMethodIncompatible = 701
    case paymentInsufficientFunds = 702
    case paymentSourceDoesNotExists = 703
    case paymentOperationUnsupported = 704
    case paymentExtraFunds = 705
    case transactionNotAllowed = 706
    
    // Wrapper
    case encoding
    case decoding
    case invalidState
}
