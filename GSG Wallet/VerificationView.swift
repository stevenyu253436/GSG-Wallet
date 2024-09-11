//
//  VerificationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct VerificationView: View {
    var phoneNumber: String // 从 RegisterView 传入的手机号
    var password: String     // 从 RegisterView 传入的密码
    @State private var verificationCode: [String] = Array(repeating: "", count: 6) // Create an array of 6 strings
    @Binding var isRegistered: Bool // 从 RegisterView 传入

    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @Environment(\.presentationMode) var presentationMode // 用于关闭当前视图
    @FocusState private var focusedField: Int? // Tracks which TextField is currently focused

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
                    TextField("", text: Binding(
                        get: { verificationCode[index] },
                        set: { newValue in
                            handleInput(newValue, at: index)
                        })
                    )
                    .keyboardType(.numberPad)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .focused($focusedField, equals: index) // Bind focus to this TextField
                }
            }
            .padding(.horizontal)
            .onAppear {
                focusedField = 0 // Start by focusing on the first field
            }
            
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
    
    // 处理输入的函数
    private func handleInput(_ newValue: String, at index: Int) {
        // 如果输入超过1个字符，将剩余字符分配给下一个输入框
        if newValue.count > 1 {
            let chars = Array(newValue)
            verificationCode[index] = String(chars[0])
            
            if index < 5 {
                // 将剩下的字符分配给接下来的输入框
                for i in 1..<chars.count {
                    if index + i <= 5 {
                        verificationCode[index + i] = String(chars[i])
                    }
                }
                // 设置焦点到下一个输入框
                focusedField = min(index + chars.count, 5)
            } else {
                focusedField = nil // 当到最后一位时，关闭键盘
            }
        } else {
            // 如果只有一个字符，正常处理并移动到下一个框
            verificationCode[index] = newValue
            if newValue.count == 1 {
                moveToNextField(from: index)
            }
        }
        print("Current verificationCode array: \(verificationCode)")
    }
    
    private func moveToNextField(from index: Int) {
        if index < 5 {
            focusedField = index + 1
        } else {
            focusedField = nil // Dismiss the keyboard when all fields are filled
        }
    }
    
    private func validateVerificationCode() {
        print("Validating verification code: \(verificationCode.joined())")
        
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/ValidateMobileSMS") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 这里假设你已经在某处保存了 `AuthToken`，例如通过 `@AppStorage`
        @AppStorage("authToken") var authToken: String = ""  // 确保 authToken 已存储
        
        // 添加 AuthToken 到请求头
        if authToken.isEmpty {
            print("AuthToken is missing")
            return
        }
        
        request.setValue(authToken, forHTTPHeaderField: "AuthToken") // 加入 AuthToken

        let body: [String: String] = [
            "mobile": phoneNumber,
            "message": verificationCode.joined() // Join the array to create a 6-digit string
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let session = URLSession(configuration: .default, delegate: SSLPinner(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.alertMessage = "請求錯誤: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response received")
                DispatchQueue.main.async {
                    self.alertMessage = "無效的回應"
                    self.showAlert = true
                }
                return
            }
            
            print("HTTP Response Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                // 验证成功，新增会员资料
                self.addMemberDetails() { success in
                    DispatchQueue.main.async {
                        if success {
                            self.isRegistered = true // 设置为 true, 返回 LoginView
                        }
                        self.returnToRegisterView() // 成功后仍然返回 RegisterView
                    }
                }
            } else if httpResponse.statusCode == 401 {
                // 401 错误处理
                DispatchQueue.main.async {
                    self.alertMessage = "驗證失敗，請確認您的驗證碼並重試。"
                    self.showAlert = true
                    self.returnToRegisterView()
                }
            } else {
                // 处理其他状态码
                DispatchQueue.main.async {
                    self.alertMessage = "驗證失敗，請重試。"
                    self.showAlert = true
                    self.returnToRegisterView()
                }
            }
        }.resume()
    }
    
    // 新增会员资料
    private func addMemberDetails(completion: @escaping (Bool) -> Void) {
        // 模拟添加会员资料的逻辑
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/AddMember") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 获取存储的AuthToken
        @AppStorage("authToken") var authToken: String = ""
        
        // 检查AuthToken是否存在
        if authToken.isEmpty {
            print("AuthToken is missing")
            completion(false)
            return
        }
        
        // 添加AuthToken到请求头
        request.setValue(authToken, forHTTPHeaderField: "AuthToken")
        
        let body: [String: String] = [
            "mobile": phoneNumber,
            "password": password // 使用从 RegisterView 传来的密码
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Add member request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to add member.")
                completion(false)
                return
            }
            
            print("Member added successfully.")
            completion(true)
        }.resume()
    }
    
    private func returnToRegisterView() {
        self.presentationMode.wrappedValue.dismiss()  // 返回到 RegisterView
    }
    
    // Focus on the next text field
    private func focusNextField(at index: Int) {
        // This function will allow to programmatically focus on the next field if needed
        // Implement it using UITextField or a custom focus logic in case of need
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(phoneNumber: "0988123456", password: "123456", isRegistered: .constant(false))
    }
}
