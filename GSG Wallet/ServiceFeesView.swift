//
//  ServiceFeesView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct ServiceFeesView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(languageSpecificText(zhText: "購買USDT", enText: "Buy USDT"))) {
                    Text("1.00%")
                }
                Section(header: Text(languageSpecificText(zhText: "出售USDT", enText: "Sell USDT"))) {
                    Text(languageSpecificText(zhText: "1.00%(最低 5.00USDT)", enText: "1.00% (minimum 5.00 USDT)"))
                }
                Section(header: Text(languageSpecificText(zhText: "提現到IBAN", enText: "Withdraw to IBAN"))) {
                    Text(languageSpecificText(zhText: "€5.00/筆", enText: "€5.00/per"))
                }
                Section(header: Text(languageSpecificText(zhText: "USDT轉入", enText: "USDT Transfer In"))) {
                    Text(languageSpecificText(zhText: "免費", enText: "Free"))
                }
                Section(header: Text(languageSpecificText(zhText: "USDT轉出(ETH/ERC20)", enText: "USDT Transfer Out (ETH/ERC20)"))) {
                    Text(languageSpecificText(zhText: "60.00USDT/筆", enText: "60.00 USDT/per"))
                }
                Section(header: Text(languageSpecificText(zhText: "GSG Wallet行內轉帳", enText: "GSG Wallet Internal Transfer"))) {
                    Text(languageSpecificText(zhText: "1.00USDT/筆", enText: "1.00 USDT/transaction"))
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationTitle(languageSpecificText(zhText: "服務費用", enText: "Service Fees"))
    }
    
    // Helper method to return the correct language-specific text
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct ServiceFeesView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceFeesView()
    }
}
