//
//  CurrencyListView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

enum ActionType {
    case recharge
    case withdraw
}

struct CurrencyListView: View {
    var erc20Balance: Double = 15.0 // 示例 ERC20 余额
    var trc20Balance: Double = 21.8 // 示例 TRC20 余额
    var actionType: ActionType
    
    @State private var showWithdrawView = false // 控制 WithdrawView 的显示
    
    var body: some View {
        List {
            // 充值用的 NavigationLink
            if actionType == .recharge {
                NavigationLink(destination: RechargeView()) {
                    CurrencyRow(currencyName: "USD", currencyDescription: "US Dollars", iconName: "dollarsign")
                }
                NavigationLink(destination: RechargeView()) {
                    CurrencyRow(currencyName: "USDT", currencyDescription: "Tether", iconName: "tether-usdt-logo")
                }
//                NavigationLink(destination: RechargeView()) {
//                    CurrencyRow(currencyName: "BTC", currencyDescription: "Bitcoin", iconName: "bitcoin-btc-logo")
//                }
//                NavigationLink(destination: RechargeView()) {
//                    CurrencyRow(currencyName: "ETH", currencyDescription: "Ethereum", iconName: "ethereum-eth-logo")
//                }
            } else {
                // 提现用的 HStack 和 fullScreenCover
                HStack {
                    CurrencyRow(currencyName: "USD", currencyDescription: "US Dollars", iconName: "dollarsign")
                    Spacer()
                    Button(action: {
                        showWithdrawView = true
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    CurrencyRow(currencyName: "USDT", currencyDescription: "Tether", iconName: "tether-usdt-logo")
                    Spacer()
                    Button(action: {
                        showWithdrawView = true
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("幣種清單")
        .fullScreenCover(isPresented: $showWithdrawView) {
            WithdrawView(erc20Balance: erc20Balance, trc20Balance: trc20Balance)
        }
        .onDisappear {
            // 显示 TabBar
            UITabBar.appearance().isHidden = false
        }
    }
    
    // 根据 actionType 和币种名称选择导航到的视图
    @ViewBuilder
    private func destinationView(for currency: String) -> some View {
        switch actionType {
        case .recharge:
            RechargeView()
        case .withdraw:
            EmptyView() // 在这里不使用 NavigationLink，而是通过 fullScreenCover 来显示 WithdrawView
        }
    }
}

struct CurrencyRow: View {
    var currencyName: String
    var currencyDescription: String
    var iconName: String
    
    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.green)
            VStack(alignment: .leading) {
                Text(currencyName)
                    .font(.headline)
                Text(currencyDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}

struct CurrencyListView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyListView(erc20Balance: 15.0, trc20Balance: 21.8, actionType: .recharge)
    }
}
