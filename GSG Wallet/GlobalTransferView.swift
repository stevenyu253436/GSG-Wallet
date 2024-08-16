//
//  GlobalTransferView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct GlobalTransferView: View {
    @State private var selectedRegion = "SEPA(IBAN)"
    @State private var isShowingCountrySelection = false
    @State private var paymentAmount: String = ""
    @State private var receiveAmount: String = ""
    @State private var message: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("全球速匯")
                .font(.title)
                .padding(.top, 20)
            
            Text("請仔細核對交易資訊，以免造成資產損失。")
                .font(.subheadline)
                .foregroundColor(.purple)
                .padding(.vertical, 10)
            
            // 区域选择
            VStack(alignment: .leading, spacing: 5) {
                Text("區款到")
                    .font(.headline)
                
                Button(action: {
                    isShowingCountrySelection = true
                }) {
                    HStack {
                        Text(selectedRegion)
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingCountrySelection) {
                    CountrySelectionView()
                }
            }
            
            // 付款金额
            VStack(alignment: .leading, spacing: 5) {
                Text("付款")
                    .font(.headline)
                
                HStack {
                    TextField("輸入金額", text: $paymentAmount)
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
                Text("可用餘額: 0.00 USD")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // 接收金额
            VStack(alignment: .leading, spacing: 5) {
                Text("接收")
                    .font(.headline)
                
                HStack {
                    TextField("輸入金額", text: $receiveAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Text("USD")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            
            // 附言
            VStack(alignment: .leading, spacing: 5) {
                Text("附言")
                    .font(.headline)
                
                TextField("請輸入附言", text: $message)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Spacer()
            
            // 确认按钮
            Button(action: {
                // 确认操作
            }) {
                Text("確認")
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
    }
}

struct GlobalTransferView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalTransferView()
    }
}
