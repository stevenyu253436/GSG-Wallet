//
//  UserInfoView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct UserInfoView: View {
    @State private var showCameraActionSheet = false
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                // 头像
                ZStack {
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 60, height: 60)
                    
                    Text("\(globalFirstName.prefix(1))\(globalLastName.prefix(1))")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Text(maskedPhoneNumber(globalPhoneNumber)) // Use the masked phone number
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("\(globalFirstName) \(globalLastName)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    showCameraActionSheet.toggle() // 显示相机选项
                }) {
                    Image(systemName: "camera")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .confirmationDialog("選擇操作", isPresented: $showCameraActionSheet) {
            Button("拍照") {
                imagePickerSourceType = .camera
                showImagePicker = true
            }
            Button("相簿") {
                imagePickerSourceType = .photoLibrary
                showImagePicker = true
            }
            Button("取消", role: .cancel) { }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: imagePickerSourceType, selectedImage: $selectedImage)
        }
    }
    
    func maskedPhoneNumber(_ phoneNumber: String) -> String {
        guard phoneNumber.count == 10 else { return phoneNumber } // Ensure it's 10 characters
        let start = phoneNumber.prefix(3)  // First 3 digits
        let end = phoneNumber.suffix(3)    // Last 3 digits
        return "\(start)****\(end)"
    }
}
