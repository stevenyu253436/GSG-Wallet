//
//  ERC20TransactionManager.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation
import BigInt
import CryptoSwift

let infuraURL = "https://mainnet.infura.io/v3/117e8c240b0e46c7a86747939f3bd44e"
let erc20ContractAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7" // Mainnet USDT Contract

// Function to withdraw ERC20 USDT without using web3swift
func withdrawERC20USDT(fromAddress: String, toAddress: String, amount: Double, privateKey: String, completion: @escaping (Bool, String?) -> Void) {
    let amountInWei = BigUInt(amount * pow(10, 6)) // Convert amount to smallest unit
    
    let transactionData = createERC20TransferData(toAddress: toAddress, amount: amountInWei)
    
    // Step 1: Create raw transaction
    let rawTransaction = [
        "from": fromAddress,
        "to": erc20ContractAddress,
        "data": transactionData,
        "gas": "60000",
        "gasPrice": "20000000000" // 20 Gwei
    ] as [String: Any]
    
    // Step 2: Sign the transaction with the private key
    guard let signedTransaction = signTransaction(rawTransaction: rawTransaction, privateKey: privateKey) else {
        completion(false, "Failed to sign transaction")
        return
    }
    
    // Step 3: Broadcast the signed transaction
    broadcastTransaction(signedTransaction: signedTransaction) { success, txHash in
        completion(success, txHash)
    }
}

// Function to create ERC20 transfer data
func createERC20TransferData(toAddress: String, amount: BigUInt) -> String {
    let functionSignature = "a9059cbb" // ERC20 transfer function selector
    let paddedToAddress = padLeft(String(toAddress.dropFirst(2)), length: 64) // Remove "0x" from address and convert to String
    let paddedAmount = padLeft(String(amount, radix: 16), length: 64) // Convert amount to hex and pad
    
    return "0x" + functionSignature + paddedToAddress + paddedAmount
}

// Function to pad strings with leading zeros
func padLeft(_ value: String, length: Int) -> String {
    return String(repeating: "0", count: length - value.count) + value
}

// Function to sign the raw transaction using the private key
func signTransaction(rawTransaction: [String: Any], privateKey: String) -> String? {
    // You would need to serialize the raw transaction here, hash it, and then sign it using the private key.
    // This is where the `secp256k1` library can be used to handle signing.
    
    // Example pseudo-code for signing (you need to implement serialization and signing):
    let serializedTransaction = serializeTransaction(rawTransaction) // Serialize the transaction
    let transactionHash = serializedTransaction.sha256() // Hash the transaction using CryptoSwift's sha256
    
    // Sign the hash with the private key
    let signature = try? signWithPrivateKey(hash: transactionHash, privateKey: privateKey)
    
    // Append the signature to the serialized transaction
    let signedTransaction = serializedTransaction + (signature ?? "")
    return signedTransaction
}

// Function to broadcast the signed transaction
func broadcastTransaction(signedTransaction: String, completion: @escaping (Bool, String?) -> Void) {
    let url = URL(string: infuraURL)!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let jsonBody = [
        "jsonrpc": "2.0",
        "method": "eth_sendRawTransaction",
        "params": [signedTransaction],
        "id": 1
    ] as [String: Any]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            completion(false, "No response from server")
            return
        }
        
        // Explicitly unwrap and check the JSON response
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let result = json["result"] as? String {
                    completion(true, result) // Transaction hash
                } else if let jsonError = json["error"] as? [String: Any],
                          let errorMessage = jsonError["message"] as? String {
                    completion(false, errorMessage)
                } else {
                    completion(false, "Unknown error")
                }
            }
        } catch {
            completion(false, "Failed to parse server response")
        }
    }.resume()
}

// Implement transaction serialization and signing logic here...
func serializeTransaction(_ transaction: [String: Any]) -> String {
    // Serialize the transaction (convert it into a raw format for signing)
    // This would involve encoding the transaction parameters.
    return ""
}

func signWithPrivateKey(hash: String, privateKey: String) throws -> String {
    // Sign the hash with the private key using secp256k1 or any other cryptography library
    return ""
}
