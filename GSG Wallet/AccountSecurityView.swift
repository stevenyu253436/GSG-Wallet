//
//  AccountSecurityView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationError: Identifiable {
    let id = UUID()  // 每个实例都有唯一的标识符
    let message: String
}

struct AccountSecurityView: View {
    @State private var isFaceIDEnabled = false
    @State private var authenticationError: AuthenticationError?

    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text("修改手機號碼")) {
                    Label("修改手機號碼", systemImage: "phone.fill")
                }

                NavigationLink(destination: Text("變更信箱")) {
                    Label("變更信箱", systemImage: "envelope.fill")
                }

                NavigationLink(destination: Text("登入密碼")) {
                    Label("登入密碼", systemImage: "lock.fill")
                }

                NavigationLink(destination: Text("支付密碼")) {
                    Label("支付密碼", systemImage: "key.fill")
                }

                Toggle(isOn: $isFaceIDEnabled) {
                    Label("面容/指紋登入", systemImage: "faceid")
                }
                .onChange(of: isFaceIDEnabled) { newValue in
                    if newValue {
                        authenticateUser()
                    }
                }
            }
        }
        .navigationTitle("帳戶&安全")
        .listStyle(GroupedListStyle())
        .alert(item: $authenticationError) { error in
            Alert(title: Text("Authentication Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "需要Face ID/Touch ID驗證啟用此功能"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isFaceIDEnabled = true
                    } else {
                        if let error = authError {
                            authenticationError = AuthenticationError(message: error.localizedDescription)
                        }
                    }
                }
            }
        } else {
            // 如果设备不支持生物识别
            authenticationError = AuthenticationError(message: error?.localizedDescription ?? "不支持生物识别")
        }
    }
}

struct AccountSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSecurityView()
    }
}
