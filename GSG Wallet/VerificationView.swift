//
//  VerificationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct VerificationView: View {
    var phoneNumber: String // 添加这个属性来接收手机号
    @State private var verificationCode: String = ""
    @Binding var isRegistered: Bool // 从 RegisterView 传入

    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode // 用于关闭当前视图

    var body: some View {
        VStack(spacing: 20) {
            Text("驗證碼")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Text("驗證碼已發送至手機號碼: ****\(String(phoneNumber.suffix(4)))")
                .font(.headline)
                .foregroundColor(.gray)

            HStack(spacing: 5) {
                ForEach(0..<6) { index in
                    TextField("", text: $verificationCode)
                        .keyboardType(.numberPad)
                        .frame(width: 50, height: 50)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal)

            Spacer()

            Button(action: {
                validateVerificationCode()
            }) {
                Text("確認")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("驗證碼")
    }
    
    private func validateVerificationCode() {
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/ValidateMobileSMS") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = [
            "mobile": phoneNumber,
            "message": verificationCode
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "請求錯誤: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.alertMessage = "無效的回應"
                    self.showAlert = true
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                // 验证成功，回到登录页面
                DispatchQueue.main.async {
                    self.isRegistered = true // 设置为 true, 返回 LoginView
                }
            } else {
                // 验证失败，显示错误信息
                DispatchQueue.main.async {
                    self.alertMessage = "驗證失敗，請確認您的驗證碼並重試。"
                    self.showAlert = true
                }
            }
        }.resume()
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(phoneNumber: "0988123456", isRegistered: .constant(false))
    }
}
