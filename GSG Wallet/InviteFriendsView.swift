//
//  InviteFriendsView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct InviteFriendsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("推薦好友，贏現金獎勵")
                .font(.headline)
                .padding(.top, 20)
            
            Text("使用你的邀請碼每邀請並激活成功1人，您和受邀人都會得到€5.00的獎勵。")
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Image(systemName: "link")
                    .foregroundColor(.gray)
                Text("www.union.cash")
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    // 添加复制链接的代码
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            HStack {
                Text("邀請碼")
                    .font(.body)
                    .foregroundColor(.gray)
                Spacer()
                Text("140381")
                    .font(.body)
                    .fontWeight(.bold)
                Button(action: {
                    // 添加复制邀请码的代码
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            HStack {
                Text("已邀請數量")
                    .font(.body)
                    .foregroundColor(.gray)
                Spacer()
                Text("0")
                    .font(.body)
                    .fontWeight(.bold)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("邀請好友")
    }
}

struct InviteFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendsView()
    }
}
