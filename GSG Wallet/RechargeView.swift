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
    @State private var qrCodeImage: UIImage? // Store the generated QR code image

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
                if let qrCodeImage = qrCodeImage {
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200)
                }
                
                Image("tether-usdt-logo")  // 你的 USDT 图标名称
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .onAppear {
                qrCodeImage = generateQRCode(from: selectedAddress) // Generate QR code image when view appears
            }
            
            HStack {
                Button(action: {
                    // 切换到 ETH/ERC20 网络
                    selectedAddress = globalERC20Address
                    qrCodeImage = generateQRCode(from: selectedAddress) // Update the QR code
                }) {
                    Text("ETH/ERC20")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // 切换到 Tron/TRC20 网络
                    selectedAddress = globalTRC20Address
                    qrCodeImage = generateQRCode(from: selectedAddress) // Update the QR code
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
                if let qrCodeImage = qrCodeImage {
                    UIImageWriteToSavedPhotosAlbum(qrCodeImage, nil, nil, nil) // Save the image to the photo library
                }
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
            // Define the desired scale factor for the QR code image resolution
            let scaleX = 300 / outputImage.extent.size.width  // Adjust the 300 to your desired width
            let scaleY = 300 / outputImage.extent.size.height // Adjust the 300 to your desired height
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
                let qrCodeImage = UIImage(cgImage: cgimg)
                
                // Add the Tether logo on top of the QR code
                return combineImages(qrCodeImage: qrCodeImage, logo: UIImage(named: "tether-usdt-logo")!)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func combineImages(qrCodeImage: UIImage, logo: UIImage) -> UIImage {
        let size = qrCodeImage.size

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the QR code image
        qrCodeImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        // Calculate the position and size for the logo (e.g., make it 1/4 the size of the QR code)
        let logoSize = CGSize(width: size.width * 0.25, height: size.height * 0.25)
        let logoOrigin = CGPoint(x: (size.width - logoSize.width) / 2, y: (size.height - logoSize.height) / 2)
        
        // Draw the logo on top of the QR code
        logo.draw(in: CGRect(origin: logoOrigin, size: logoSize))
        
        // Get the combined image
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return combinedImage ?? qrCodeImage
    }
}

struct RechargeView_Previews: PreviewProvider {
    static var previews: some View {
        RechargeView()
    }
}
