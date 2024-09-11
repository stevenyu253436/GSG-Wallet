//
//  EtherscanResponse.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/9/11.
//

import Foundation

struct EtherscanResponse: Codable {
    let status: String
    let message: String
    let result: String // The balance in the response is a string representation of the number
}
