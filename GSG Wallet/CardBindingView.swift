//
//  CardBindingView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct CardBindingView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 标题部分
            HStack {
                Text("卡片")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 使用 Menu 视图来实现下拉菜单
                Menu {
                    Button(action: {
                        // 订单操作
                    }) {
                        Text("訂單")
                    }
                    
                    Button(action: {
                        // 交易规则操作
                    }) {
                        Text("交易規則")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            // 显示卡片图像
            Image("34303FE5-7B89-429E-BB32-151D3AE74B8E") // 第一张卡片图像
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
            
            // 显示卡片选项（实体卡和虚拟卡）
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: "creditcard")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Text("實體卡")
                    Text("€49.90")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.purple, lineWidth: 2)
                )
                
                VStack {
                    Image(systemName: "creditcard.fill")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    Text("虛擬卡")
                    Text("€5.00")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                )
            }
            
            // 显示操作按钮
            VStack(spacing: 10) {
                Button(action: {
                    // 申请银行卡操作
                }) {
                    Text("申請銀行卡")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // 绑定银行卡操作
                }) {
                    Text("綁定銀行卡")
                        .font(.headline)
                        .foregroundColor(.purple)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("卡片")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        // 订单操作
                    }) {
                        Text("訂單")
                    }
                    
                    Button(action: {
                        // 交易规则操作
                    }) {
                        Text("交易規則")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct CardBindingView_Previews: PreviewProvider {
    static var previews: some View {
        CardBindingView()
    }
}
