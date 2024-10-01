//
//  WithdrawView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

// Extension to hide the keyboard when tapping outside the TextField
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct WithdrawView: View {
    @State private var withdrawalAmount: String = ""
    @State private var selectedChainType: String = "ETH/ERC20"
    @State private var withdrawalAddress: String = ""
    @State private var recipient: String = ""
    @State private var networkFee: Double = 0.0
    @State private var netAmount: Double = 0.0
    @State private var isShowingScanner = false // 控制 QR 码扫描器的显示
    @State private var isShowingConfirmationSheet = false // New state for showing the confirmation sheet

    var erc20Balance: Double  // ERC20 的可用余额
    var trc20Balance: Double  // TRC20 的可用余额
    @Environment(\.presentationMode) var presentationMode

    // 计算显示的余额，基于选中的链名称
    var displayedBalance: Double {
        return selectedChainType == "ETH/ERC20" ? erc20Balance : trc20Balance
    }
    
    var body: some View {
        if isShowingScanner {
            QRCodeScannerView(
                didFindCode: { scannedCode in
                    withdrawalAddress = scannedCode
                    isShowingScanner = false
                },
                didFail: {
                    isShowingScanner = false
                },
                onDismiss: {
                    isShowingScanner = false
                }
            )
        } else {
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
                        
                        // Create a container HStack for the image and text
                        HStack(spacing: 5) {
                            Image("tether-usdt-logo") // Replace this with the actual name of your USDT icon image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24) // Adjust the size as needed
                            
                            Text("USDT")
                        }
                        .padding(.horizontal, 15) // Add some padding inside the HStack for a better appearance
                        .padding(.vertical) // Optional padding for the top and bottom
                        .background(Color.gray.opacity(0.1)) // Apply the background to the entire HStack
                        .cornerRadius(10) // Apply the corner radius to the entire HStack
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
                        MultilineTextField(text: $withdrawalAddress, placeholder: "請輸入提現地址") // Add the placeholder text
                            .frame(height: 80) // Adjust the height to your preference
                            .padding(.horizontal, 5)
                        
                        Button(action: {
                            isShowingScanner = true
                        }) {
                            Image(systemName: "qrcode.viewfinder")
                                .foregroundColor(.blue)
                                .padding()
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
                    // Calculate net amount
                    if let amount = Double(withdrawalAmount) {
                        netAmount = amount - networkFee
                    }
                    // Show confirmation sheet
                    isShowingConfirmationSheet = true
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
            .onTapGesture {
                self.hideKeyboard() // Add this to hide the keyboard when tapping outside
            }
            .sheet(isPresented: $isShowingConfirmationSheet) {
                WithdrawalConfirmationView(
                    withdrawalAmount: withdrawalAmount,
                    fee: networkFee,
                    totalAmount: (Double(withdrawalAmount) ?? 0) + networkFee,
                    netAmount: netAmount,
                    recipientName: recipient,
                    withdrawalAddress: withdrawalAddress,
                    isPresented: $isShowingConfirmationSheet
                )
                .presentationDetents([.medium, .fraction(0.5)]) // Set the detents here
                .padding(.horizontal, 20) // Add padding to ensure the sheet content is nicely framed
            }
        }
    }
}

struct WithdrawView_Previews: PreviewProvider {
    static var previews: some View {
        WithdrawView(erc20Balance: 15.0, trc20Balance: 21.8)
    }
}
