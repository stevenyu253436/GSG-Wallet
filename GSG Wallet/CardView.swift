//
//  CardView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct CardView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"
    @State private var isBalanceHidden = true
    @State private var cardBalance: Double = 1234.56
    @State private var transactions: [Transaction] = [
        Transaction(descriptionZH: "手續費出", descriptionEN: "Fee Deduction", date: "2024-06-30 06:20:00", amount: -1.075153),
        Transaction(descriptionZH: "手續費出", descriptionEN: "Fee Deduction", date: "2024-06-15 06:20:00", amount: -0.964300)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text(languageSpecificText(zhText: "卡片", enText: "Cards"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // 使用 Menu 视图来实现下拉菜单
                    Menu {
                        Button(action: {
                            // 订单操作
                            print("訂單選項被點擊")
                        }) {
                            Text(languageSpecificText(zhText: "訂單", enText: "Order"))
                        }
                        
                        Button(action: {
                            // 交易规则操作
                            print("交易規則選項被點擊")
                        }) {
                            Text(languageSpecificText(zhText: "交易規則", enText: "Transaction Rules"))
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(languageSpecificText(zhText: "總資產", enText: "Total assets"))
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            isBalanceHidden.toggle()
                        }) {
                            Image(systemName: isBalanceHidden ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack(alignment: .firstTextBaseline) {
                        if isBalanceHidden {
                            Text("******")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            Text("\(cardBalance, specifier: "%.2f")")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Text("USD")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                ZStack {
                    // 使用图片作为背景
                    Image("34303FE5-7B89-429E-BB32-151D3AE74B8E")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 400, height: 220) // 你可以根据实际需求调整大小

                    HStack {
                        VStack(alignment: .leading) {
                            Text("Physical Card")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("5554 7488 0012 1074")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                }
                
                HStack(spacing: 40) {
                    Button(action: {
                        // 转入操作
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(languageSpecificText(zhText: "轉入", enText: "Deposit"))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        // 转出操作
                    }) {
                        VStack {
                            Image(systemName: "arrow.up.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(languageSpecificText(zhText: "轉出", enText: "Withdraw"))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        // 查看密碼操作
                    }) {
                        VStack {
                            Image(systemName: "creditcard")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(languageSpecificText(zhText: "查看密碼", enText: "View PIN"))
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        // 挂失/解挂操作
                    }) {
                        VStack {
                            Image(systemName: "lock")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(languageSpecificText(zhText: "掛失/解掛", enText: "Report/Unlock"))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                List(transactions) { transaction in
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                        
                        VStack(alignment: .leading) {
                            Text(transaction.localizedDescription(selectedLanguage: selectedLanguage))
                                .font(.headline)
                            Text(transaction.date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("\(transaction.amount, specifier: "%.6f") USDT")
                            .font(.headline)
                            .foregroundColor(transaction.amount < 0 ? .red : .green)
                    }
                    .padding(.vertical, 5)
                }
                
                Spacer()
            }
            .padding(.top)
            .navigationBarHidden(true)
        }
    }
    
    // 一个辅助方法，用于根据当前语言选择显示的文本
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct Transaction: Identifiable {
    var id = UUID()
    var descriptionZH: String
    var descriptionEN: String
    var date: String
    var amount: Double
    
    func localizedDescription(selectedLanguage: String) -> String {
        return selectedLanguage == "zh-Hant" ? descriptionZH : descriptionEN
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
