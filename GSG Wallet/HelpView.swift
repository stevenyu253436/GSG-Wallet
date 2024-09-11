//
//  HelpView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()

                // 右上角的 X 按钮
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            // 使用 HStack 将文本移到左边
            HStack {
                Text("您好 👋")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40)
                
                Spacer() // 添加 Spacer() 将文本推到左侧
            }
            .padding(.horizontal) // 添加水平内边距，让文本不紧贴屏幕边缘

            // 中间部分，显示主要内容
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("開始對話")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("通常在 2 小時內回覆")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                .padding()
                
                HStack {
                    // 应用程序的Logo
                    Image("appLogo") // 确保该图像资源存在于项目中
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    // 新对话按钮
                    Button(action: {
                        // 按钮的动作，可以在这里处理对话的逻辑
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                                .foregroundColor(.white)
                            Text("新對話")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                    .padding(.top, 10)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)

            Spacer()

            // 底部部分，显示运行的信息
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                Text("我們在 Intercom 上運行")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("幫助")
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
