//
//  TRC20TransactionManager.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation
import CryptoSwift
import secp256k1 // Import the secp256k1 library

struct TRC20TransferResponse: Decodable {
    let result: TRC20Result?
    let transaction: [String: Any]? // Adjust this based on the structure of the transaction details
    
    private enum CodingKeys: String, CodingKey {
        case result
        case transaction
    }
    
    struct TRC20Result: Decodable {
        let result: Bool
        
        private enum CodingKeys: String, CodingKey {
            case result
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            result = (try? container.decode(Bool.self, forKey: .result)) ?? false
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try? container.decode(TRC20Result.self, forKey: .result)
        
        // Update this part to correctly handle the transaction as a dictionary
        if let transactionData = try? container.decode([String: AnyDecodable].self, forKey: .transaction) {
            self.transaction = transactionData.mapValues { $0.value }
        } else {
            transaction = nil
        }
    }
}

// Helper struct to decode Any JSON values
struct AnyDecodable: Decodable {
    let value: Any
    
    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            value = int
        } else if let double = try? decoder.singleValueContainer().decode(Double.self) {
            value = double
        } else if let string = try? decoder.singleValueContainer().decode(String.self) {
            value = string
        } else if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            value = bool
        } else if let array = try? decoder.singleValueContainer().decode([AnyDecodable].self) {
            value = array.map { $0.value }
        } else if let dictionary = try? decoder.singleValueContainer().decode([String: AnyDecodable].self) {
            value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: try decoder.singleValueContainer(), debugDescription: "Unsupported value")
        }
    }
}

func withdrawTRC20USDT(fromAddress: String, toAddress: String, amount: Double, privateKey: String, completion: @escaping (Bool, String?) -> Void) {
    // Convert amount to the smallest unit (TRC20 USDT has 6 decimals)
    let amountInSun = Int(amount * pow(10.0, 6.0))

    // TRC20 USDT Contract Address
    let contractAddress = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"
    
    // Encode the function call to the smart contract (transfer method)
    let functionSelector = "a9059cbb" // The 4-byte function selector for "transfer(address,uint256)"
    
    // Prepare the recipient address in hex (remove '0x' if present)
    let recipientAddress = toAddress.tronHexString.dropFirst(2)
    let paddedRecipientAddress = String(repeating: "0", count: 64 - recipientAddress.count) + recipientAddress
    
    // Encode the transfer amount as a hex string, ensuring it is 64 characters long
    let amountHex = String(amountInSun, radix: 16)
    let paddedAmountHex = String(repeating: "0", count: 64 - amountHex.count) + amountHex
    
    // Combine the encoded function selector, recipient address, and amount
    let data = functionSelector + paddedRecipientAddress + paddedAmountHex
    
    // Create the transaction dictionary
    let transferData: [String: Any] = [
        "contract_address": contractAddress,
        "owner_address": fromAddress,
        "function_selector": functionSelector,
        "parameter": paddedRecipientAddress + paddedAmountHex,
        "call_value": 0,
        "fee_limit": 100000000, // Set a reasonable fee limit (e.g., 100 TRX)
        "visible": true // Set to true if using Base58 addresses, false for hex
    ]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: transferData) else {
        print("Error: Unable to convert transfer data to JSON")
        completion(false, nil)
        return
    }
    
    // Step 1: Use the `triggerSmartContract` API to create the raw transaction
    let url = URL(string: "https://api.trongrid.io/wallet/triggersmartcontract")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error making transaction request: \(error)")
            completion(false, nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(false, nil)
            return
        }
        
        do {
            let transferResponse = try JSONDecoder().decode(TRC20TransferResponse.self, from: data)
            
            if let trc20Result = transferResponse.result, trc20Result.result {
                print("Transfer transaction created successfully")
                
                // Step 2: Now you need to sign the transaction using your private key
                guard let transactionJson = transferResponse.transaction else {
                    print("Transaction JSON is missing")
                    completion(false, nil)
                    return
                }
                
                if let transactionData = try? JSONSerialization.data(withJSONObject: transactionJson) {
                    if let signedTransaction = signTransaction(transactionData: transactionData, privateKey: privateKey) {
                        // Step 6: Broadcast the signed transaction
                        broadcastTransaction(signedTransaction) { success, transactionHash in
                            completion(success, transactionHash)
                        }
                    } else {
                        print("Signing transaction failed")
                        completion(false, nil)
                    }
                }
            } else {
                print("Failed to create transfer transaction")
                completion(false, nil)
            }
        } catch {
            print("Error decoding transaction response: \(error)")
            completion(false, nil)
        }
    }.resume()
}

// Helper function to sign the transaction using the private key
func signTransaction(transactionData: Data, privateKey: String) -> Data? {
    let privateKeyBytes = privateKey.hexToBytes()
    
    guard privateKeyBytes.count == 32 else {
        print("Invalid private key")
        return nil
    }
    
    // Create a secp256k1 context
    guard let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
        print("Failed to create secp256k1 context")
        return nil
    }
    
    // Prepare the message hash to be signed
    let hash = transactionData.sha256()
    
    // Convert the hash to an UnsafePointer<UInt8>
    let hashPointer = hash.withUnsafeBytes { $0.baseAddress!.assumingMemoryBound(to: UInt8.self) }
    
    // Convert the private key bytes to an UnsafePointer<UInt8>
    let privateKeyPointer = privateKeyBytes.withUnsafeBytes { $0.baseAddress!.assumingMemoryBound(to: UInt8.self) }

    // Prepare the signature
    var signature = secp256k1_ecdsa_signature()
    
    // Sign the hash
    let result = secp256k1_ecdsa_sign(context, &signature, hashPointer, privateKeyPointer, nil, nil)
    
    // Check if signing was successful
    if result != 1 {
        print("Error signing transaction")
        return nil
    }
    
    // Convert the signature to a DER-encoded byte array
    var signatureLength: size_t = 72 // Maximum length of DER-encoded signature
    var derSignature = [UInt8](repeating: 0, count: 72)
    
    secp256k1_ecdsa_signature_serialize_der(context, &derSignature, &signatureLength, &signature)
    
    // Clean up context
    secp256k1_context_destroy(context)
    
    // Decode the original transaction JSON
    guard var signedTransaction = try? JSONSerialization.jsonObject(with: transactionData, options: []) as? [String: Any] else {
        print("Invalid transaction data")
        return nil
    }

    // Add the signature to the transaction
    signedTransaction["signature"] = [Data(derSignature.prefix(signatureLength)).base64EncodedString()]

    // Convert back to Data for broadcasting
    return try? JSONSerialization.data(withJSONObject: signedTransaction)
}

// Helper function to broadcast the signed transaction
func broadcastTransaction(_ signedTransaction: Data, completion: @escaping (Bool, String?) -> Void) {
    let url = URL(string: "https://api.trongrid.io/wallet/broadcasttransaction")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = signedTransaction
    
    // Debug: Print request body
    if let jsonString = String(data: signedTransaction, encoding: .utf8) {
        print("Signed Transaction JSON:\n\(jsonString)")
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error broadcasting transaction: \(error)")
            completion(false, nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(false, nil)
            return
        }
        
        do {
            if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Full Broadcast API response: \(responseDict)")
                
                if let txID = responseDict["txID"] as? String {
                    print("Transaction broadcasted successfully with ID: \(txID)")
                    completion(true, txID)
                } else if let errorMessage = responseDict["message"] as? String {
                    let decodedMessage = String(data: Data(base64Encoded: errorMessage) ?? Data(), encoding: .utf8) ?? errorMessage
                    print("Failed to broadcast transaction. Error: \(decodedMessage)")
                    completion(false, nil)
                } else {
                    print("Failed to broadcast transaction with an unknown error")
                    completion(false, nil)
                }
            } else {
                print("Failed to decode broadcast response")
                completion(false, nil)
            }
        } catch {
            print("Error decoding broadcast response: \(error)")
            completion(false, nil)
        }
    }.resume()
}

// Helper extension to convert Tron address to hex
extension String {
    func hexToBytes() -> [UInt8] {
        var bytes = [UInt8]()
        var startIndex = self.startIndex
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: 2)
            let byteString = self[startIndex..<endIndex]
            if let byte = UInt8(byteString, radix: 16) {
                bytes.append(byte)
            }
            startIndex = endIndex
        }
        return bytes
    }
    
    var tronHexString: String {
        guard let base58Bytes = Base58.decode(self) else {
            // Handle the error case appropriately if decoding fails
            print("Error: Invalid Base58 string")
            return ""
        }
        let hexString = base58Bytes.toHexString()
        return hexString
    }
}
