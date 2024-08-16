//
//  HomeView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct HomeView: View {
    @State private var isBalanceHidden = false
    @State private var usdtAmount: Double = 0.0  // 用於顯示 USDT 金額
    @State private var usdAmount: Double = 0.0   // 用於顯示 USD 金額
    @State private var ethAmount: Double = 0.0   // 用於顯示 ETH 金額
    @State private var btcAmount: Double = 0.0   // 用於顯示 BTC 金額
    @State private var isShowingCurrencyList = false
    @State private var selectedActionType: ActionType = .recharge
    @State private var showMessageCenter = false

    var body: some View {
        NavigationView { // 將 NavigationView 放在最外層
            VStack {
                // GSG Wallet 標題
                Text("GSG Wallet")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // 上方顯示總資產和金額
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("總資產")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        // 眼睛圖標
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
                            Text("\(usdtAmount, specifier: "%.2f")")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Text("USD")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // 充值、提現、兌換、全球速匯按鈕
                HStack(spacing: 30) {
                    // 使用 NavigationLink 進行導航
                    NavigationLink(destination: CurrencyListView(usdtAmount: usdtAmount, actionType: .recharge)) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("充值")
                                .foregroundColor(.black)
                        }
                    }
                    
                    NavigationLink(destination: CurrencyListView(usdtAmount: usdtAmount, actionType: .withdraw)) {
                        VStack {
                            Image(systemName: "arrow.up.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("提現")
                                .foregroundColor(.black)
                        }
                    }
                    
                    
                    // 使用 NavigationLink 進行導航到兌換頁面
                    NavigationLink(destination: ExchangeView(usdtAmount: usdtAmount)) {
                        VStack {
                            Image(systemName: "arrow.left.and.right.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("兌換")
                                .foregroundColor(.black)
                        }
                    }
                    
                    NavigationLink(destination: GlobalTransferView()) {
                        VStack {
                            Image(systemName: "globe")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("全球速匯")
                                .foregroundColor(.black)
                        }
                    }
                }
                .font(.title3)
                .padding()

                // 資產列表
                List {
                    AssetRow(assetName: "USD", assetDescription: "US Dollars", balance: "0.00", equivalent: "≈$0.00", iconName: "dollarsign")
                    AssetRow(assetName: "USDT", assetDescription: "Tether", balance: "\(usdtAmount)", equivalent: "≈$\(usdtAmount)", iconName: "tether-usdt-logo") // 顯示 USDT 的金額
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    fetchUSDTAmount()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MessageCenterView()) {
                        Image(systemName: "bell")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    func fetchUSDTAmount() {
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/GetWallets") else {
            print("Invalid URL")
            return
        }
        
        // 準備請求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 請求的 body
        let body: [String: String] = [
            "address": "TT8i1yRfNqGL7uudFNgruUFJpqchJjXYZF"
        ]
        
        // 將 body 轉換為 JSON 數據
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode JSON")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: SSLPinner(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to fetch data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let walletResponse = try JSONDecoder().decode(WalletResponse.self, from: data)
                if let usdtWallet = walletResponse.data.responseWallets.first(where: { $0.coinType == "USDT" }) {
                    DispatchQueue.main.async {
                        self.usdtAmount = usdtWallet.amount
                    }
                } else {
                    print("USDT not found")
                }
                
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

struct AssetRow: View {
    var assetName: String
    var assetDescription: String
    var balance: String
    var equivalent: String
    var iconName: String // 新增一個屬性來傳遞圖標名稱

    var body: some View {
        HStack(alignment: .top) {
            // 在這裡添加更大的圖標
            VStack {
                // 根據傳入的 iconName 使用圖片
                Image(iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green) // 如果是自定義圖片可以去掉這
            }
            .padding(.trailing, 5) // 與文本保持一點距離
            
            VStack(alignment: .leading) {
                Text(assetName)
                    .font(.headline)
                Text(assetDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(balance)
                    .font(.headline)
                Text(equivalent)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
    }
}
