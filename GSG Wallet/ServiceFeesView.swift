//
//  ServiceFeesView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct ServiceFeesView: View {
    var body: some View {
        VStack {
            Form {
                Section(header: Text("購買USDT")) {
                    Text("1.00%")
                }
                Section(header: Text("出售USDT")) {
                    Text("1.00%(最低 5.00USDT)")
                }
                Section(header: Text("提現到IBAN")) {
                    Text("€5.00/筆")
                }
                Section(header: Text("USDT轉入")) {
                    Text("免費")
                }
                Section(header: Text("USDT轉出(ETH/ERC20)")) {
                    Text("60.00USDT/筆")
                }
                Section(header: Text("Unioncash行內轉帳")) {
                    Text("1.00USDT/筆")
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationTitle("服務費用")
    }
}

struct ServiceFeesView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceFeesView()
    }
}
