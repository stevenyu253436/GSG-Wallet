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
    
    // State variable to control visibility of asset balance
    @State private var isBalanceHidden = false

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
                Button(action: {
                    // Handle recharge action here
                }) {
                    VStack {
                        Image(systemName: "arrow.down.circle")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("充值")
                            .foregroundColor(.black)
                    }
                }
                
                Button(action: {
                    // Handle withdraw action here
                }) {
                    VStack {
                        Image(systemName: "arrow.up.circle")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("提現")
                            .foregroundColor(.black)
                    }
                }
                
                Button(action: {
                    // Handle exchange action here
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
            .padding()
            
            Spacer()
        }
        .navigationBarTitle(Text(assetName), displayMode: .inline)
        .padding()
    }
}

struct AssetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssetDetailView(
            assetName: "USDT-ERC20",
            assetBalance: 13.800000,
            equivalentBalance: 13.80,
            availableBalance: 13.800000,
            unavailableBalance: 0.0
        )
    }
}
