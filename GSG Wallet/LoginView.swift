//
//  LoginView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter {$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct LoginView: View {
    @Binding var isLoggedIn: Bool  // 绑定登录状态
    
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var isRegistering = false  // 控制注册页面的显示
    @State private var isForgotPasswordActive = false // 控制忘记密码页面的显示
    @State private var showErrorMessage = false
    @State private var errorMessage = ""

    // 使用 AccountView 中的 selectedLanguageKey 存储语言选择
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"  // 默认语言为繁体中文
    @AppStorage("authToken") var authToken: String = ""  // Store authToken globally after login

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 欢迎标题
                Text(selectedLanguage == "zh-Hant" ? "歡迎回來" : "Welcome back")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.top, 50)

                // 手机号码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedLanguage == "zh-Hant" ? "手機號碼" : "Phone")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        
                        Text("+886") // 默认国家代码
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        TextField("0912345678", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .font(.headline)
                            .foregroundColor(.black)
                            .onChange(of: phoneNumber) { newValue in
                                globalPhoneNumber = newValue // Update the global variable whenever `phoneNumber` changes
                            }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // 密码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedLanguage == "zh-Hant" ? "輸入您的密碼" : "Enter your password")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        if isPasswordHidden {
                            SecureField(selectedLanguage == "zh-Hant" ? "輸入您的密碼" : "Enter your password", text: $password)
                                .font(.headline)
                                .foregroundColor(.black)
                        } else {
                            TextField(selectedLanguage == "zh-Hant" ? "輸入您的密碼" : "Enter your password", text: $password)
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
                
                // 忘记密码链接
                HStack {
                    Spacer()
                    Button(action: {
                        isForgotPasswordActive = true
                    }) {
                        Text(selectedLanguage == "zh-Hant" ? "忘記密碼？" : "Forgot?")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal)
                
                // 登录按钮
                Button(action: {
                    login()  // Call login function
                }) {
                    Text(selectedLanguage == "zh-Hant" ? "登入" : "Log in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(password.isEmpty ? Color(.systemGray4) : Color.purple)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(password.isEmpty)
                
                Spacer()
                
                // 注册链接
                HStack {
                    Text(selectedLanguage == "zh-Hant" ? "創建GSG Wallet帳戶" : "Create a GSG Wallet account")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    NavigationLink(destination: RegisterView(isRegistered: $isRegistering), isActive: $isRegistering) {
                        Text(selectedLanguage == "zh-Hant" ? "註冊" : "Sign up")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .toolbar {
                // 右上角的语言切换按钮
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        toggleLanguage()
                    }) {
                        Text(selectedLanguage == "zh-Hant" ? "中文" : "ENGLISH")
                            .foregroundColor(.purple)
                    }
                }
            }
            .background(
                NavigationLink(destination: ForgotPasswordView(), isActive: $isForgotPasswordActive) {
                    EmptyView()
                }
            )
            .onTapGesture {
                UIApplication.shared.endEditing(true)  // Dismiss the keyboard when tapping outside
            }
        }
    }
    
    // 切换语言的方法
    private func toggleLanguage() {
        selectedLanguage = selectedLanguage == "zh-Hant" ? "en" : "zh-Hant"
    }
    
    // Login function that calls the API
    private func login() {
        guard let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/GetLoginToken") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Body content with phone number and password
        let body: [String: String] = [
            "mobile": phoneNumber,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            // Print the request body for debugging
            if let requestBody = request.httpBody {
                print("Request body: \(String(data: requestBody, encoding: .utf8) ?? "Unable to encode body")")
            }
        } catch {
            self.errorMessage = "Error creating request."
            self.showErrorMessage = true
            print("Error encoding request body: \(error.localizedDescription)")
            return
        }
        
        // Use custom session with the SSLPinner delegate
        let session = URLSession(configuration: .default, delegate: SSLPinner(), delegateQueue: nil)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to login: \(error.localizedDescription)"
                    self.showErrorMessage = true
                }
                print("Error during login request: \(error.localizedDescription)")
                return
            }
            
            // Print the raw response for debugging
            if let data = data {
                print("Raw response: \(String(data: data, encoding: .utf8) ?? "No response data")")
            } else {
                print("No response data received")
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No response from server."
                    self.showErrorMessage = true
                }
                return
            }
            
            do {
                // Parse the response
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if let token = loginResponse.data?.authToken {
                        print("Received authToken: \(token)")  // Debugging authToken
                        self.authToken = token  // Save authToken globally
                        self.isLoggedIn = true  // Update login state
                    } else {
                        self.errorMessage = self.selectedLanguage == "zh-Hant" ? "登入失敗，請檢查信息" : "Login failed, please check your details"
                        self.showErrorMessage = true
                        print("Failed to retrieve authToken from response")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = self.selectedLanguage == "zh-Hant" ? "無法解析響應數據" : "Failed to decode response."
                    self.showErrorMessage = true
                }
                print("Error decoding response: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// Response model for decoding the login response
struct LoginResponse: Codable {
    struct Data: Codable {
        let authToken: String
    }
    let data: Data?
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
