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
    
    @State private var showAlert = false // State variable to control alert visibility
    @State private var alertMessage = "" // State variable for dynamic alert message
    
    // Assuming you have the private key stored or passed as a parameter
    let privateKey = "your-private-key" // Replace with your actual private key

    var availableBalance: Double { // Assuming you pass the available balance to this view
        // Here you can pass the actual available balance value when creating this view
        return 20.0 // Replace this with the actual balance value from your data
    }
    
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
                    if let amount = Double(withdrawalAmount), amount > availableBalance {
                        alertMessage = "可用餘額不足！"
                        showAlert = true // Show alert if withdrawal amount exceeds available balance
                    } else {
                        createRawTransfer(amount: Double(withdrawalAmount) ?? 0, toAddress: withdrawalAddress) { success in
                            if success {
                                alertMessage = "提現成功！"
                            } else {
                                alertMessage = "提現失敗，請稍後再試。"
                            }
                            showAlert = true
                        }
                    }
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertMessage),
                dismissButton: .default(Text("確認"))
            )
        }
    }
    
    // Function to create a raw transfer
    func createRawTransfer(amount: Double, toAddress: String, completion: @escaping (Bool) -> Void) {
        let fromAddress = globalTRC20Address // Replace with your actual TRC20 USDT wallet address
        
        withdrawTRC20USDT(fromAddress: fromAddress, toAddress: toAddress, amount: amount, privateKey: privateKey) { success, transactionHash in
            if success {
                print("Withdrawal successful! Transaction Hash: \(transactionHash ?? "N/A")")
                completion(true)
            } else {
                print("Withdrawal failed.")
                completion(false)
            }
        }
    }
}
