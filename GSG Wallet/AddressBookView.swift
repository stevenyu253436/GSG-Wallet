//
//  AddressBookView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct AddressBookView: View {
    @State private var showAddAddressView = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // 中间的图标和提示文字
            VStack {
                Image(systemName: "doc.text.magnifyingglass") // 使用类似的图标
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                
                Text("沒有常用地址")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .navigationTitle("地址簿")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddAddressView()) {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .font(.title) // 如果想调整“+”号的大小
                }
            }
        }
    }
}

struct AddressBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddressBookView()
    }
}
