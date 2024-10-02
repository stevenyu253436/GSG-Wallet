//
//  TRC20TransactionManager.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation
import CryptoSwift

struct TRC20TransferResponse: Codable {
    let result: Bool
    let transaction: Data? // Adjust this to a more specific structure if you know the transaction details
}

func withdrawTRC20USDT(fromAddress: String, toAddress: String, amount: Double, privateKey: String, completion: @escaping (Bool, String?) -> Void) {
    // Step 1: Convert amount to the smallest unit (TRC20 USDT has 6 decimals)
    let amountInSun = Int(amount * pow(10.0, 6.0))
    
    // Step 2: Create the raw transfer data (JSON)
    let transferData: [String: Any] = [
        "owner_address": fromAddress.tronHexString,
        "to_address": toAddress.tronHexString,
        "asset_name": "USDT", // TRC20 USDT name
        "amount": amountInSun
    ]
    
    guard let jsonData = try? JSONSerialization.data(withJSONObject: transferData) else {
        print("Error: Unable to convert transfer data to JSON")
        completion(false, nil)
        return
    }
    
    // Step 3: Prepare the URL request to the TronGrid API
    let url = URL(string: "https://api.trongrid.io/wallet/triggersmartcontract")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = jsonData
    
    // Step 4: Send the request to create the transfer transaction
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
            
            if transferResponse.result {
                print("Transfer transaction created successfully")
                
                // Step 5: Now you need to sign the transaction using your private key
                guard let transactionJson = transferResponse.transaction else {
                    print("Transaction JSON is missing")
                    completion(false, nil)
                    return
                }
                
                if let transactionData = try? JSONSerialization.data(withJSONObject: transactionJson) {
                    let signedTransaction = signTransaction(transactionData: transactionData, privateKey: privateKey)
                    
                    // Step 6: Broadcast the signed transaction
                    broadcastTransaction(signedTransaction) { success, transactionHash in
                        completion(success, transactionHash)
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
func signTransaction(transactionData: Data, privateKey: String) -> Data {
    let hash = transactionData.sha256()
    let privateKeyBytes = privateKey.hexToBytes()
    let signature = try! CryptoSwift.ECC.ECDSA.secp256k1.sign(hash, privateKey: privateKeyBytes)
    return signature
}

// Helper function to broadcast the signed transaction
func broadcastTransaction(_ signedTransaction: Data, completion: @escaping (Bool, String?) -> Void) {
    let url = URL(string: "https://api.trongrid.io/wallet/broadcasttransaction")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = signedTransaction
    
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
            if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let txID = responseDict["txID"] as? String {
                print("Transaction broadcasted successfully with ID: \(txID)")
                completion(true, txID)
            } else {
                print("Failed to broadcast transaction")
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
