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

            Button(action: {
                // 注册操作完成，返回登录页面
                isRegistered = true
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
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegistered: .constant(false))
    }
}
