//
//  WithdrawConfirmationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/10/2.
//

import Foundation
import SwiftUI

struct WithdrawalConfirmationView: View {
    var withdrawalAmount: String
    var fee: Double
    var totalAmount: Double
    var netAmount: Double
    var recipientName: String
    var withdrawalAddress: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("提現 USDT")
                .font(.headline)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("提現金額")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(withdrawalAmount) USDT")
                }
                
                HStack {
                    Text("手續費")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(String(format: "%.6f", fee)) USDT")
                }
                
                HStack {
                    Text("扣款總額")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(String(format: "%.6f", totalAmount)) USDT")
                }
                
                HStack {
                    Text("到賬數量")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(String(format: "%.6f", netAmount)) USDT")
                }
                
                HStack {
                    Text("收款姓名")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(recipientName)
                }
                
                HStack {
                    Text("提現地址")
                        .foregroundColor(.gray)
                    Spacer()
                    Text(withdrawalAddress)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Cancel and Confirm buttons
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("取消")
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Confirm withdrawal logic here
                    isPresented = false
                }) {
                    Text("確認")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
