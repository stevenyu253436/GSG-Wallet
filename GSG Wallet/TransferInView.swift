//
//  TransferInView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct TransferInView: View {
    @State private var transferAmount: String = ""
    @State private var availableBalance: Double = 0.0
    var body: some View {
        VStack(spacing: 20) {
            Text("轉入")
                .font(.title)
                .padding(.top, 20)
            
            // 表单部分
            VStack(alignment: .leading, spacing: 5) {
                Text("From")
                    .font(.headline)
                
                HStack {
                    Text("USD賬戶")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .padding()
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("To")
                    .font(.headline)
                
                Text("Hung-kuo Chen\n5554 7488 0012 1074")
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("轉賬類型")
                    .font(.headline)
                
                HStack {
                    Text("USD")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .padding()
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("轉賬金額")
                    .font(.headline)
                
                HStack {
                    TextField("輸入金額", text: $transferAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        // 输入全部金额的逻辑
                    }) {
                        Text("全部")
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    Text("USD")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Text("可用餘額: \(String(format: "%.2f", availableBalance)) EUR")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 确认按钮
            Button(action: {
                // 处理转入逻辑
            }) {
                Text("轉入")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .padding()
        .navigationBarTitle("轉入", displayMode: .inline) // 设置导航栏标题
    }
}

struct TransferInView_Previews: PreviewProvider {
    static var previews: some View {
        TransferInView()
    }
}
