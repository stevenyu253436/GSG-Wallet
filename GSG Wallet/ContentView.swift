//
//  ContentView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct ContentView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"
    @State private var showRechargeView = false
    @State private var showWithdrawView = false
    
    var erc20Balance: Double = 15.0 // 示例 ERC20 余额
    var trc20Balance: Double = 21.8 // 示例 TRC20 余额
    
    var body: some View {
        TabView {
            // 首頁頁面
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(selectedLanguage == "zh-Hant" ? "首頁" : "Home")
                }
                .fullScreenCover(isPresented: $showRechargeView) {
                    RechargeView()
                }
                .fullScreenCover(isPresented: $showWithdrawView) {
                    WithdrawView(erc20Balance: erc20Balance, trc20Balance: trc20Balance)
                }
            
            // 卡片頁面
            CardView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text(selectedLanguage == "zh-Hant" ? "卡片" : "Cards")
                }
            
            // 賬戶頁面
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text(selectedLanguage == "zh-Hant" ? "賬戶" : "Account")
                }
        }
        .onAppear {
            // 在切换语言后刷新UI
            Localizable.setLanguage(selectedLanguage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
