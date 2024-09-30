//
//  RechargeView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct RechargeView: View {
    // 使用 @State 来存储当前选择的地址
    @State private var selectedAddress: String = globalERC20Address
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("充值")
                .font(.title)
                .padding(.top, 20)
            
            Text("USDT")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ZStack {
                Image(uiImage: generateQRCode(from: selectedAddress))
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 200, height: 200)
                
                Image("tether-usdt-logo")  // 你的 USDT 图标名称
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            HStack {
                Button(action: {
                    // 切换到 ETH/ERC20 网络
                    selectedAddress = globalERC20Address
                }) {
                    Text("ETH/ERC20")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // 切换到 Tron/TRC20 网络
                    selectedAddress = globalTRC20Address
                }) {
                    Text("Tron/TRC20")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            
            Text("地址")
                .font(.headline)
                .foregroundColor(.gray)
            
            // 在地址栏旁边添加复制按钮
            HStack {
                Text(selectedAddress) // 动态显示当前选中的地址
                    .font(.subheadline)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                Button(action: {
                    UIPasteboard.general.string = selectedAddress
                }) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            Spacer()
            
            Button(action: {
                // 保存图片的操作
            }) {
                Text("保存圖片")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct RechargeView_Previews: PreviewProvider {
    static var previews: some View {
        RechargeView()
    }
}
