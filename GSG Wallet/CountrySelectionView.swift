//
//  CountrySelectionView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct CountrySelectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    
    let countries = [
        "SEPA(IBAN)", "中國香港", "巴西", "新加坡", "越南", "馬來西亞", "澳大利亞", "美國", "印度尼西亞", "日本", "泰國", "孟加拉國", "印度", "緬甸", "阿拉伯聯合酋長國"
    ]
    
    var filteredCountries: [String] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCountries, id: \.self) { country in
                    Button(action: {
                        // 处理国家选择
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Text(country)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜尋")
            .navigationTitle("選擇國家")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
