//
//  ContentView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct ContentView: View {
    @State private var showRechargeView = false
    @State private var showWithdrawView = false
    
    var body: some View {
        TabView {
            // 首頁頁面
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首頁")
                }
                .fullScreenCover(isPresented: $showRechargeView) {
                    RechargeView()
                }
                .fullScreenCover(isPresented: $showWithdrawView) {
                    WithdrawView(availableBalance: 21.8)
                }
            
            // 卡片頁面
            CardView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("卡片")
                }
            
            // 賬戶頁面
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("賬戶")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
