//
//  RegisterView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct RegisterView: View {
    @Binding var isRegistered: Bool // 用于绑定注册状态，注册完成后返回登录页面
    @Environment(\.presentationMode) var presentationMode // 添加这行来获取 presentationMode
    
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var showInvitationField = false // 控制邀请码输入框的显示
    @State private var invitationCode = "" // 存储邀请码
    @State private var navigateToVerification = false // 控制页面跳转

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to GSG Wallet")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.purple)
                .padding(.top, 50)

            VStack(alignment: .leading, spacing: 8) {
                Text("手機號碼")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack {
                    Image(systemName: "flag.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)

                    Text("+886")
                        .font(.headline)
                        .foregroundColor(.gray)

                    TextField("輸入您的手機號碼", text: $phoneNumber)
                        .keyboardType(.phonePad)
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("輸入您的密碼")
                    .font(.headline)
                    .foregroundColor(.gray)

                HStack {
                    if isPasswordHidden {
                        SecureField("輸入您的密碼", text: $password)
                            .font(.headline)
                            .foregroundColor(.black)
                    } else {
                        TextField("輸入您的密碼", text: $password)
                            .font(.headline)
                            .foregroundColor(.black)
                    }

                    Button(action: {
                        isPasswordHidden.toggle()
                    }) {
                        Image(systemName: isPasswordHidden ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            NavigationLink(
                destination: VerificationView(phoneNumber: phoneNumber, password: password, isRegistered: $isRegistered),
                isActive: $navigateToVerification
            ) {
                Button(action: {
                    // 先发送网络请求
                    sendVerificationCode { success in
                        if success {
                            // 如果成功，跳转到验证码页面
                            navigateToVerification = true
                        } else {
                            // 处理失败的情况
                            print("Failed to send verification code")
                        }
                    }
                }) {
                    Text("註冊")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(password.isEmpty ? Color(.systemGray4) : Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(phoneNumber.isEmpty || password.isEmpty) // 当电话号码或密码为空时禁用按钮
            }
            
            Spacer()

            HStack {
                Text("已經有一個帳戶？")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    isRegistered = true
                    presentationMode.wrappedValue.dismiss() // 直接返回登录页面
                }) {
                    Text("登入")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
    
    // 发送验证码的网络请求函数
    private func sendVerificationCode(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/MobileSMS") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 获取存储的AuthToken
        @AppStorage("authToken") var authToken: String = ""
        
        // 检查是否有有效的authToken
        if authToken.isEmpty {
            print("AuthToken is missing")
            completion(false)
            return
        }

        // 添加AuthToken到请求头
        request.setValue(authToken, forHTTPHeaderField: "AuthToken")
        
        let body: [String: String] = ["mobile": phoneNumber]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        // 打印调试信息
        print("Request URL: \(request.url?.absoluteString ?? "No URL")")
        print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let bodyData = request.httpBody, let bodyString = String(data: bodyData, encoding: .utf8) {
            print("Request Body: \(bodyString)")
        } else {
            print("Request Body: No Body")
        }
        
        // 创建自定义的 URLSession，使用 SSLPinner 作为委托
        let session = URLSession(configuration: .default, delegate: SSLPinner(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                completion(false)
                return
            }
            
            if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                print("Response Body: \(bodyString)")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("Request successful")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("Request failed with status code: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }.resume()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegistered: .constant(false))
    }
}
