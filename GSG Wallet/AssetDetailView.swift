//
//  AssetDetailView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/9/30.
//

import Foundation
import SwiftUI

struct AssetDetailView: View {
    var assetName: String
    var assetBalance: Double
    var equivalentBalance: Double
    var availableBalance: Double = 0.0
    var unavailableBalance: Double = 0.0
    var erc20Balance: Double
    var trc20Balance: Double

    // State variable to control visibility of asset balance
    @State private var isBalanceHidden = false
    @State private var showWithdrawView = false // For fullScreenCover
    @State private var showRechargeView = false // New state variable for RechargeView
    @State private var showExchangeView = false
    @State private var hasHistory = false // New variable to control history display

    var body: some View {
        VStack(spacing: 20) {
            Text(assetName)
                .font(.title)
                .padding(.top, 20)
            
            HStack {
                if isBalanceHidden {
                    Text("******") // Hidden balance display
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                } else {
                    Text(String(format: "%.6f", assetBalance))
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                }
                
                // Eye button to toggle balance visibility
                Button(action: {
                    isBalanceHidden.toggle()
                }) {
                    Image(systemName: isBalanceHidden ? "eye.slash" : "eye")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
            }

            // Control visibility of equivalentBalance
            if isBalanceHidden {
                Text("*****")
                    .foregroundColor(.gray)
            } else {
                Text(String(format: "≈$%.2f", equivalentBalance))
                    .foregroundColor(.gray)
            }
            
            HStack {
                VStack {
                    Text("可用")
                        .foregroundColor(.gray)
                    if isBalanceHidden {
                        Text("*****")
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Text(String(format: "%.6f", availableBalance))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("不可用")
                        .foregroundColor(.gray)
                    if isBalanceHidden {
                        Text("*****")
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Text(String(format: "%.6f", unavailableBalance))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            HStack(spacing: 80) {
                // Navigate to RechargeView using NavigationLink
                NavigationLink(destination: RechargeView(), isActive: $showRechargeView) {
                    Button(action: {
                        showRechargeView = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("充值")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                // Open WithdrawView using fullScreenCover
                Button(action: {
                    showWithdrawView = true
                }) {
                    VStack {
                        Image(systemName: "arrow.up.circle")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("提現")
                            .foregroundColor(.black)
                    }
                }
                
                // Navigate to ExchangeView using NavigationLink
                NavigationLink(destination: ExchangeView(usdtAmount: erc20Balance + trc20Balance), isActive: $showExchangeView) {
                    Button(action: {
                        showExchangeView = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.left.and.right.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("兌換")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Bottom section for history and more
            VStack {
                HStack {
                    // History text
                    Text("歷史")
                        .font(.headline)
                        .padding(.leading, 16)
                    Spacer()
                    // More with chevron
                    HStack {
                        Text("更多")
                            .font(.headline)
                        Image(systemName: "chevron.right")
                            .font(.headline)
                    }
                    .padding(.trailing, 16)
                }
                
                if !hasHistory {
                    Spacer()
                    
                    // Center icon
                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.purple)
                    
                    Spacer()
                }
            }
            .padding(.bottom, 40) // Adjust padding as needed
        }
        .padding()
        .fullScreenCover(isPresented: $showWithdrawView) {
            WithdrawView(erc20Balance: erc20Balance, trc20Balance: trc20Balance)
        }
    }
}

struct AssetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssetDetailView(
            assetName: "USDT-ERC20",
            assetBalance: 13.800000,
            equivalentBalance: 13.80,
            availableBalance: 13.800000,
            unavailableBalance: 0.0,
            erc20Balance: 13.800000,
            trc20Balance: 0
        )
    }
}
