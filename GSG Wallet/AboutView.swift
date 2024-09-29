//
//  AboutView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // 显示应用程序的图标
            Image("appLogo") // 替换为实际的图片资源名称
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)

            // 显示版本号
            Text("版本號碼1.40")
                .font(.headline)
                .foregroundColor(.gray)

            // 服务条款
            HStack {
                Image(systemName: "book")
                    .foregroundColor(.purple)
                Text("服務協定")
                    .foregroundColor(.purple)
                    .font(.headline)
            }
            .padding(.bottom, 40) // 添加一定的底部内边距
            
            Spacer()
        }
        .padding() // 添加一些 padding 来让视图不会贴边
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("關於")
                    .font(.headline)
                    .bold()
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
