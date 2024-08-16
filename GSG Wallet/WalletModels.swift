//
//  WalletModels.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import Foundation

// 定義 Wallet 結構體，表示每一個錢包
struct Wallet: Codable {
    let coinType: String
    let amount: Double
}

// 定義 API 響應的結構體
struct WalletResponse: Codable {
    let data: ResponseData
}

// 定義數據結構體
struct ResponseData: Codable {
    let responseWallets: [Wallet]
}
