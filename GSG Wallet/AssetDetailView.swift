//
//  AssetDetailView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/9/30.
//

import Foundation
import SwiftUI

struct EtherscanTransaction: Identifiable {
    var id = UUID()
    var hash: String
    var timeStamp: String
    var from: String
    var to: String
    var value: String
    var tokenSymbol: String
    
    var formattedDate: String {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}

struct AssetDetailView: View {
    var assetName: String
    var assetBalance: Double
    var equivalentBalance: Double
    var availableBalance: Double = 0.0
    var unavailableBalance: Double = 0.0
    var erc20Balance: Double
    var trc20Balance: Double
    var isERC20: Bool = false // Add this
    var isTRC20: Bool = false // Add this
    
    // State variable to control visibility of asset balance
    @State private var isBalanceHidden = false
    @State private var showWithdrawView = false // For fullScreenCover
    @State private var showRechargeView = false // New state variable for RechargeView
    @State private var showExchangeView = false
    @State private var hasHistory = false // New variable to control history display
    @State private var showHistoryDetail = false // New variable for HistoryDetailView navigation
    @State private var transactions: [EtherscanTransaction] = [] // For storing fetched transactions

    var body: some View {
        VStack(spacing: 20) {
            Text(assetName)
                .font(.title)
                .padding(.top, 20)
            
            HStack {
                if isBalanceHidden {
                    Text("******") // Hidden balance display
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                } else {
                    Text(String(format: "%.6f", assetBalance))
                        .font(.system(size: 48))
                        .fontWeight(.bold)
                }
                
                // Eye button to toggle balance visibility
                Button(action: {
                    isBalanceHidden.toggle()
                }) {
                    Image(systemName: isBalanceHidden ? "eye.slash" : "eye")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding(.leading, 10)
                }
            }

            // Control visibility of equivalentBalance
            if isBalanceHidden {
                Text("*****")
                    .foregroundColor(.gray)
            } else {
                Text(String(format: "≈$%.2f", equivalentBalance))
                    .foregroundColor(.gray)
            }
            
            HStack {
                VStack {
                    Text("可用")
                        .foregroundColor(.gray)
                    if isBalanceHidden {
                        Text("*****")
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Text(String(format: "%.6f", availableBalance))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                
                Spacer()
                
                VStack {
                    Text("不可用")
                        .foregroundColor(.gray)
                    if isBalanceHidden {
                        Text("*****")
                            .font(.title3)
                            .fontWeight(.semibold)
                    } else {
                        Text(String(format: "%.6f", unavailableBalance))
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(.horizontal, 40)
            
            HStack(spacing: 80) {
                // Navigate to RechargeView using NavigationLink
                NavigationLink(destination: RechargeView(), isActive: $showRechargeView) {
                    Button(action: {
                        showRechargeView = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("充值")
                                .foregroundColor(.black)
                        }
                    }
                }
                
                // Open WithdrawView using fullScreenCover
                Button(action: {
                    showWithdrawView = true
                }) {
                    VStack {
                        Image(systemName: "arrow.up.circle")
                            .font(.largeTitle)
                            .foregroundColor(.black)
                        Text("提現")
                            .foregroundColor(.black)
                    }
                }
                
                // Navigate to ExchangeView using NavigationLink
                NavigationLink(destination: ExchangeView(usdtAmount: erc20Balance + trc20Balance), isActive: $showExchangeView) {
                    Button(action: {
                        showExchangeView = true
                    }) {
                        VStack {
                            Image(systemName: "arrow.left.and.right.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                            Text("兌換")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            
            // Bottom section for history and more
            VStack {
                HStack {
                    // History text
                    Text("歷史")
                        .font(.headline)
                        .padding(.leading, 16)
                    Spacer()
                    // Use NavigationLink for "More"
                    NavigationLink(destination: HistoryDetailView(), isActive: $showHistoryDetail) {
                        Button(action: {
                            showHistoryDetail = true
                        }) {
                            HStack {
                                Text("更多")
                                    .font(.headline)
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                            }
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                // Display transaction history
                if isERC20 {
                    VStack {
                        List(transactions) { transaction in
                            HStack {
                                if transaction.value.contains("-") {
                                    Image(systemName: "arrow.up.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                } else {
                                    Image(systemName: "arrow.down.circle")
                                        .font(.largeTitle)
                                        .foregroundColor(.black)
                                        .padding(.trailing, 10)
                                }

                                VStack(alignment: .leading) {
                                    if transaction.value.contains("-") {
                                        Text("提現") // Withdrawal
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    } else {
                                        Text("充值") // Deposit
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }

                                    Text(transaction.formattedDate)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if let value = Double(transaction.value) {
                                    Text("+\(value / 1_000_000, specifier: "%.6f") \(transaction.tokenSymbol)")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                } else {
                                    Text("Invalid Value")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onAppear(perform: fetchERC20History)
                } else if isTRC20 {
                    List(transactions) { transaction in
                        HStack {
                            Image(systemName: transaction.value.contains("-") ? "arrow.up.circle" : "arrow.down.circle")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                                .padding(.trailing, 10)
                            
                            VStack(alignment: .leading) {
                                Text(transaction.value.contains("-") ? "提現" : "充值") // Withdrawal or Deposit
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                Text(transaction.formattedDate)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if let value = Double(transaction.value) {
                                Text("+\(value / 1_000_000, specifier: "%.6f") \(transaction.tokenSymbol)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                            } else {
                                Text("Invalid Value")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .onAppear(perform: fetchTRC20History)
                } else {
                    Spacer()
                    Image(systemName: "doc.text.magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.purple)
                    Spacer()
                }
            }
            .padding(.bottom, 40) // Adjust padding as needed
        }
        .padding()
        .fullScreenCover(isPresented: $showWithdrawView) {
            WithdrawView(erc20Balance: erc20Balance, trc20Balance: trc20Balance)
        }
    }
    
    func fetchERC20History() {
        let url = "https://api.etherscan.io/api?module=account&action=tokentx&contractaddress=0xdAC17F958D2ee523a2206206994597C13D831ec7&address=\(globalERC20Address)&startblock=0&endblock=99999999&sort=asc&apikey=H6WZH2NCZVQCQUNQJIKAH9TRFCINEKHNI5"
        
        guard let requestURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(EtherscanTransactionResponse.self, from: data)
                    if decodedResponse.status == "1" {
                        DispatchQueue.main.async {
                            self.transactions = decodedResponse.result.map {
                                EtherscanTransaction(
                                    hash: $0.hash,
                                    timeStamp: $0.timeStamp,
                                    from: $0.from,
                                    to: $0.to,
                                    value: "\($0.value)",
                                    tokenSymbol: $0.tokenSymbol
                                )
                            }
                            hasHistory = !self.transactions.isEmpty
                        }
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchTRC20History() {
        let url = "https://api.trongrid.io/v1/accounts/TT8i1yRfNqGL7uudFNgruUFJpqchJjXYZF/transactions/trc20"
        
        guard let requestURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(TRC20TransactionResponse.self, from: data)
                    if decodedResponse.success {
                        DispatchQueue.main.async {
                            self.transactions = decodedResponse.data.map {
                                EtherscanTransaction(
                                    hash: $0.transaction_id,
                                    timeStamp: "\($0.block_timestamp / 1000)", // Convert to seconds
                                    from: $0.from,
                                    to: $0.to,
                                    value: "\($0.value)",
                                    tokenSymbol: $0.token_info.symbol
                                )
                            }
                            hasHistory = !self.transactions.isEmpty
                        }
                    }
                } catch {
                    print("Error decoding TRC20 data: \(error)")
                }
            }
        }.resume()
    }
}

struct EtherscanTransactionResponse: Codable {
    let status: String
    let message: String
    let result: [EtherscanTransactionData]
}

struct EtherscanTransactionData: Codable {
    let hash: String
    let timeStamp: String
    let from: String
    let to: String
    let value: String
    let tokenSymbol: String
}

struct TRC20TransactionResponse: Codable {
    let data: [TRC20TransactionData]
    let success: Bool
}

struct TRC20TransactionData: Codable {
    let transaction_id: String
    let block_timestamp: Int
    let from: String
    let to: String
    let value: String
    let token_info: TRC20TokenInfo
}

struct TRC20TokenInfo: Codable {
    let symbol: String
    let address: String
    let decimals: Int
    let name: String
}

struct AssetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AssetDetailView(
            assetName: "USDT-ERC20",
            assetBalance: 15.000000,
            equivalentBalance: 15.00,
            availableBalance: 15.000000,
            unavailableBalance: 0.0,
            erc20Balance: 15.000000,
            trc20Balance: 0,
            isERC20: true,
            isTRC20: false
        )
    }
}
