//
//  HomeView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct HomeView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant" // 使用 AppStorage 获取当前选择的语言
    @AppStorage("authToken") var authToken: String = "" // Fetch the saved AuthToken here.
    
    @State private var isBalanceHidden = false
    // Define your ERC20 and TRC20 amounts
    @State private var usdtERC20Amount: Double = 0.00 // Example amount
    @State private var usdtTRC20Amount: Double = 0.00 // Example amount
    @State private var usdAmount: Double = 0.0   // 用於顯示 USD 金額
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
                        Text(selectedLanguage == "zh-Hant" ? "總資產" : "Total assets")
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
                            Text("\(usdAmount + usdtERC20Amount + usdtTRC20Amount, specifier: "%.2f")")
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
                    NavigationLink(destination: CurrencyListView(erc20Balance: usdtERC20Amount, trc20Balance: usdtTRC20Amount, actionType: .recharge)) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(selectedLanguage == "zh-Hant" ? "充值" : "Deposit")
                                .foregroundColor(.black)
                        }
                    }
                    
                    NavigationLink(destination: CurrencyListView(erc20Balance: usdtERC20Amount, trc20Balance: usdtTRC20Amount, actionType: .withdraw)) {
                        VStack {
                            Image(systemName: "arrow.up.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(selectedLanguage == "zh-Hant" ? "提現" : "Withdraw")
                                .foregroundColor(.black)
                        }
                    }
                    
                    // 使用 NavigationLink 進行導航到兌換頁面
                    NavigationLink(destination: ExchangeView(usdtAmount: usdtERC20Amount + usdtTRC20Amount)) {
                        VStack {
                            Image(systemName: "arrow.left.and.right.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(selectedLanguage == "zh-Hant" ? "兌換" : "Exchange")
                                .foregroundColor(.black)
                        }
                    }
                    
                    NavigationLink(destination: GlobalTransferView()) {
                        VStack {
                            Image(systemName: "globe")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text(selectedLanguage == "zh-Hant" ? "全球速匯" : "Remittance")
                                .foregroundColor(.black)
                        }
                    }
                }
                .font(.title3)
                .padding()

                // 資產列表
                List {
                    // USD Row with NavigationLink
                    NavigationLink(destination: AssetDetailView(assetName: "USD", assetBalance: usdAmount, equivalentBalance: usdAmount, availableBalance: usdAmount, unavailableBalance: 0.0, erc20Balance: 0.0, trc20Balance: 0.0)) {
                        AssetRow(
                            assetName: "USD",
                            assetDescription: "US Dollars",
                            balance: String(format: "%.2f", usdAmount), // 顯示到小數點後兩位
                            equivalent: String(format: "≈$%.2f", usdAmount), // 顯示到小數點後兩位
                            iconName: "dollarsign" // 使用合適的圖標名稱
                        )
                    }
                    
                    // USDT Row with NavigationLink
                    NavigationLink(destination: AssetDetailView(assetName: "USDT", assetBalance: usdtERC20Amount + usdtTRC20Amount, equivalentBalance: usdtERC20Amount + usdtTRC20Amount, availableBalance: usdtERC20Amount + usdtTRC20Amount, unavailableBalance: 0.0, erc20Balance: usdtERC20Amount, trc20Balance: usdtTRC20Amount)) {
                        AssetRow(
                            assetName: "USDT",
                            assetDescription: "Tether",
                            balance: String(format: "%.6f", usdtERC20Amount + usdtTRC20Amount),
                            equivalent: String(format: "≈$%.2f", usdtERC20Amount + usdtTRC20Amount),
                            iconName: "tether-usdt-logo"
                        )
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .onAppear {
                    fetchUSDTTRC20Amount()
                    fetchUSDTERC20Amount()
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
    
    func fetchUSDTTRC20Amount() {
        // Print the authToken for debugging
        print("AuthToken: \(authToken)")
        
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/GetWallets") else {
            print("Invalid URL")
            return
        }
        
        // 準備請求
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "AuthToken") // Use the saved authToken here

        // 請求的 body
        let body: [String: String] = [
            "address": globalTRC20Address
        ]
        
        // 將 body 轉換為 JSON 數據
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode JSON for USDT-TRC20: \(error.localizedDescription)")
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
                        self.usdtTRC20Amount = usdtWallet.amount
                    }
                } else {
                    print("USDT not found")
                }
                
            } catch {
                print("Failed to decode JSON for USDT-TRC20: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func fetchUSDTERC20Amount() {
        // 定义 URL 组件
        let baseUrl = "https://api.etherscan.io/api"
        let module = "account"
        let action = "tokenbalance"
        let contractAddress = "0xdAC17F958D2ee523a2206206994597C13D831ec7"
        let address = globalERC20Address
        let tag = "latest"
        let apiKey = "H6WZH2NCZVQCQUNQJIKAH9TRFCINEKHNI5"
        
        // 生成 URL 字符串
        guard let url = URL(string: "\(baseUrl)?module=\(module)&action=\(action)&contractaddress=\(contractAddress)&address=\(address)&tag=\(tag)&apikey=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to fetch data for USDT-ERC20: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received for USDT-ERC20")
                return
            }
            
            do {
                let etherscanResponse = try JSONDecoder().decode(EtherscanResponse.self, from: data)
                if etherscanResponse.status == "1" {
                    if let balance = Double(etherscanResponse.result) {
                        DispatchQueue.main.async {
                            self.usdtERC20Amount = balance / 1_000_000 // Convert from token units to decimal units
                        }
                    } else {
                        print("Failed to parse balance for USDT-ERC20")
                    }
                } else {
                    print("Error in response for USDT-ERC20: \(etherscanResponse.message)")
                }
                
            } catch {
                print("Failed to decode JSON for USDT-ERC20: \(error.localizedDescription)")
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
