//
//  MessageCenterView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct MessageCenterView: View {
    @State private var selectedTab = 0 // 用于切换“我的消息”和“公用訊息”

    var body: some View {
        VStack {
            // 顶部的切换按钮
            Picker(selection: $selectedTab, label: Text("選擇消息類型")) {
                Text("我的消息").tag(0)
                Text("公用訊息").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            // 根据选择显示不同的内容
            if selectedTab == 0 {
                MyMessagesView()
            } else {
                PublicMessagesView()
            }

            Spacer()
        }
        .navigationTitle("訊息中心")
    }
}

// 我的消息视图
struct MyMessagesView: View {
    var body: some View {
        VStack {
            // 替换为您要显示的实际消息内容
            Image(systemName: "mailbox")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.purple)
            
            Text("暫無訊息")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// 公用訊息视图
struct PublicMessagesView: View {
    var body: some View {
        VStack {
            // 替换为您要显示的实际公用讯息内容
            Text("银行卡充值手续费减免通知!")
                .font(.headline)
                .foregroundColor(.purple)
            
            Text("我们相信，对每个人来说，消费都应该简单直接，再无复杂费用。")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            Spacer()
            
            Text("2024-07-19 13:46:12")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct MessageCenterView_Previews: PreviewProvider {
    static var previews: some View {
        MessageCenterView()
    }
}
