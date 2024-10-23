//
//  TRC20Transaction.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/23.
//

import Foundation

struct TRC20Transaction: Codable {
    let transaction_id: String
    let token_info: TokenInfo
    let block_timestamp: Int
    let from: String
    let to: String
    let type: String
    let value: String
}

struct TokenInfo: Codable {
    let symbol: String
    let address: String
    let decimals: Int
    let name: String
}
