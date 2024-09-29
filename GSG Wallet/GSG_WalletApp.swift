//
//  GSG_WalletApp.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

@main
struct GSG_WalletApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false  // 使用 AppStorage 来存储登录状态
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            if isLoggedIn {
                ContentView()  // 用户已登录，展示主界面
            } else {
                LoginView(isLoggedIn: $isLoggedIn)  // 用户未登录，展示登录界面
            }
        }
    }
}
