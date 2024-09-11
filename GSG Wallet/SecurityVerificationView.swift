//
//  SecurityVerificationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct SecurityVerificationView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("安全驗證")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Image("security_verification_image") // 替换为你的安全验证图片
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 200)
            
            Text("拖動滑塊填滿拼圖")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // 在这里添加拼图验证的滑块逻辑
            Slider(value: .constant(0.5), in: 0...1)
                .padding()
            
            Button(action: {
                // 处理验证结果，关闭模态视图
                isPresented = false
            }) {
                Text("驗證")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding(20)
    }
}

// 添加 PreviewProvider 以便在 Xcode 中预览
struct SecurityVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityVerificationView(isPresented: .constant(true))
            .previewLayout(.sizeThatFits) // 设置预览布局
    }
}
