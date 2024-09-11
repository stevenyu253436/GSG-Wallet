//
//  WithdrawView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct WithdrawView: View {
    @State private var withdrawalAmount: String = ""
    @State private var selectedChainType: String = "ETH/ERC20"
    @State private var withdrawalAddress: String = ""
    @State private var recipient: String = ""
    @State private var networkFee: Double = 0.0
    @State private var netAmount: Double = 0.0
    @State private var isShowingScanner = false // 控制 QR 码扫描器的显示

    var erc20Balance: Double  // ERC20 的可用余额
    var trc20Balance: Double  // TRC20 的可用余额
    @Environment(\.presentationMode) var presentationMode

    // 计算显示的余额，基于选中的链名称
    var displayedBalance: Double {
        return selectedChainType == "ETH/ERC20" ? erc20Balance : trc20Balance
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // 添加返回按钮
            // 返回按钮和标题
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.leading, 10) // 添加适当的左边距
                }
                
                Spacer()
                
                Text("提現")
                    .font(.title)
                    .padding(.trailing, 40) // 添加适当的右边距来平衡
                
                Spacer() // 在标题的右侧添加一个 Spacer，使标题居中
            }
            .padding(.top, 20)

            // 提現金額輸入框
            VStack(alignment: .leading, spacing: 5) {
                Text("提現金額")
                    .font(.headline)
                
                HStack {
                    TextField("輸入金額", text: $withdrawalAmount)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Text("USDT")
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                // 动态显示可用余额
                Text("可用餘額: \(String(format: "%.6f", displayedBalance)) USDT")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // 提現類型選擇
            VStack(alignment: .leading, spacing: 5) {
                Text("提現類型")
                    .font(.headline)
                
                Picker("提現類型", selection: $selectedChainType) {
                    Text("鏈上轉帳").tag("鏈上轉帳")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(maxWidth: .infinity) // 调整宽度以适应全屏
            }
            
            // 鏈名稱選擇
            VStack(alignment: .leading, spacing: 5) {
                Text("鏈名稱")
                    .font(.headline)
                
                Picker("鏈名稱", selection: $selectedChainType) {
                    Text("ETH/ERC20").tag("ETH/ERC20")
                    Text("Tron/TRC20").tag("Tron/TRC20")
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .frame(maxWidth: .infinity) // 调整宽度以适应全屏
            }
            
            // 提現地址輸入框
            VStack(alignment: .leading, spacing: 5) {
                Text("提現地址")
                    .font(.headline)
                
                HStack {
                    TextField("請輸入提現地址", text: $withdrawalAddress)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                            .foregroundColor(.blue)
                            .padding()
                    }
                    .fullScreenCover(isPresented: $isShowingScanner) {
                        QRCodeScannerView { scannedCode in
                            withdrawalAddress = scannedCode
                            isShowingScanner = false
                        } didFail: {
                            // 处理用户拒绝相机权限的情况
                            isShowingScanner = false
                        } onDismiss: {
                            // Handle the dismiss action
                            isShowingScanner = false
                        }
                    }
                    
                    Button(action: {
                        // 选择地址簿中的地址功能
                    }) {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            
            // 收款人輸入框
            VStack(alignment: .leading, spacing: 5) {
                Text("收款人")
                    .font(.headline)
                
                TextField("輸入收款人", text: $recipient)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            // 网络费和到账数量
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("網絡費")
                    Spacer()
                    Text("- \(String(format: "%.6f", networkFee)) USDT")
                        .foregroundColor(.gray)
                }
                
                HStack {
                    Text("到賬數量")
                    Spacer()
                    Text("\(String(format: "%.6f", netAmount)) USDT")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)

            Spacer()
            
            // 提現按鈕
            Button(action: {
                // 提现逻辑
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("提現")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30) // 添加底部填充，确保按钮不会被遮挡
        }
        .padding()
    }
}

struct WithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawView(erc20Balance: 15.0, trc20Balance: 21.8)
    }
}
