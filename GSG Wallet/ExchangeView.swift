//
//  ExchangeView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct ExchangeView: View {
    @State private var payAccount: String = "USD賬戶"
    @State private var payCurrency: String = "USD"
    @State private var receiveCurrency: String = "USDT"
    @State private var exchangeAmount: String = ""
    @State private var availableAmount: Double

    let usdtAmount: Double // 从 HomeView 传递过来的 USDT 金额
    let currencies = ["USD", "USDT"] // 可选择的货币
    
    // 自定义初始化方法
    init(usdtAmount: Double) {
        self.usdtAmount = usdtAmount
        self._availableAmount = State(initialValue: usdtAmount)
        if self.payCurrency != "USDT" {
            self._availableAmount = State(initialValue: 0.0)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("兌換")
                .font(.title)
                .padding(.top, 20)

            // 付款账户选择
            VStack(alignment: .leading, spacing: 5) {
                Text("付款賬戶")
                    .font(.headline)
                
                HStack {
                    Text(payAccount)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .padding()
                }
            }
            
            // Pay 和 Receive 的 UI 布局
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Pay")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Picker("Select Currency", selection: $payCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                HStack {
                                    Image(systemName: currencyIcon(for: currency))
                                        .foregroundColor(currencyColor(for: currency))
                                    Text(currency)
                                }.tag(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.vertical) // 只應用垂直的 padding
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .onChange(of: payCurrency) { newCurrency in
                            updateAvailableAmount(for: newCurrency)
                        }
                    }
                    Spacer()
                    
                    Button(action: {
                        // 交换 payCurrency 和 receiveCurrency 的值
                        let tempCurrency = payCurrency
                        payCurrency = receiveCurrency
                        receiveCurrency = tempCurrency
                    }) {
                        Image(systemName: "arrow.right.arrow.left")
                            .font(.headline)
                            .padding()
                    }

                    // Receive 部分
                    VStack(alignment: .leading) {
                        Text("Receive")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Picker("Select Currency", selection: $receiveCurrency) {
                            ForEach(currencies, id: \.self) { currency in
                                HStack {
                                    Image(systemName: currencyIcon(for: currency))
                                        .foregroundColor(currencyColor(for: currency))
                                    Text(currency)
                                }.tag(currency)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.vertical) // 只應用垂直的 padding
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            
            // 兑换金额输入
            VStack(alignment: .leading, spacing: 5) {
                Text("兌換數量")
                    .font(.headline)
                
                HStack {
                    TextField("輸入金額", text: $exchangeAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        // 输入全部金额的逻辑
                        exchangeAmount = String(format: "%.6f", availableAmount)
                    }) {
                        Text("全部")
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                    
                    Text(payCurrency)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Text("可兌換金額: \(String(format: "%.6f", availableAmount)) \(payCurrency)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 确认按钮
            Button(action: {
                // 处理兑换逻辑
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
    
    // 根据货币返回相应的图标
    func currencyIcon(for currency: String) -> String {
        switch currency {
        case "USD": return "dollarsign.circle.fill"
        case "USDT": return "t.circle.fill"
        default: return "questionmark.circle.fill"
        }
    }

    // 根据货币返回相应的颜色
    func currencyColor(for currency: String) -> Color {
        switch currency {
        case "USD": return .blue
        case "USDT": return .green
        default: return .gray
        }
    }
    
    // 根据选择的币种更新可兑换金额
    func updateAvailableAmount(for currency: String) {
        if currency == "USDT" {
            availableAmount = usdtAmount
        } else {
            availableAmount = 0.0 // 假设其他货币的可兑换金额为0，你可以根据实际情况修改
        }
    }
}

struct ExchangeView_Previews: PreviewProvider {
    static var previews: some View {
        ExchangeView(usdtAmount: 1000.0) // 示例金额
    }
}
