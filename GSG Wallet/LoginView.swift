//
//  LoginView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool  // 绑定登录状态
    
    @State private var phoneNumber = "0972516868"
    @State private var password = ""
    @State private var isPasswordHidden = true
    @State private var isRegistering = false  // 控制注册页面的显示

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 欢迎标题
                Text("歡迎回來")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.top, 50)

                // 手机号码输入框
                VStack(alignment: .leading, spacing: 8) {
                    Text("手機號碼")
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
                        
                        TextField("0972516868", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // 密码输入框
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
                
                // 忘记密码链接
                HStack {
                    Spacer()
                    Button(action: {
                        // 忘记密码操作
                    }) {
                        Text("忘記密碼？")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal)
                
                // 登录按钮
                Button(action: {
                    // 这里进行用户验证，成功后设置 isLoggedIn 为 true
                    isLoggedIn = true
                }) {
                    Text("登入")
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
                    Text("創建GSG Wallet帳戶")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                    NavigationLink(destination: RegisterView(isRegistered: $isRegistering), isActive: $isRegistering) {
                        Text("註冊")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
