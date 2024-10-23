//
//  ApiResponse.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/23.
//

import Foundation

struct ApiResponse: Codable {
    let data: [TRC20Transaction]
    let success: Bool
    let meta: Meta
}

struct Meta: Codable {
    let at: Int
    let page_size: Int
}
