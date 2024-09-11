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
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"
    @State private var isFaceIDEnabled = false
    @State private var authenticationError: AuthenticationError?

    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text(languageSpecificText(zhText: "修改手機號碼", enText: "Change phone number"))) {
                    Label(languageSpecificText(zhText: "修改手機號碼", enText: "Change phone number"), systemImage: "phone.fill")
                }

                NavigationLink(destination: Text(languageSpecificText(zhText: "變更信箱", enText: "Change email"))) {
                    Label(languageSpecificText(zhText: "變更信箱", enText: "Change email"), systemImage: "envelope.fill")
                }

                NavigationLink(destination: Text(languageSpecificText(zhText: "登入密碼", enText: "Change login password"))) {
                    Label(languageSpecificText(zhText: "登入密碼", enText: "Change login password"), systemImage: "lock.fill")
                }

                NavigationLink(destination: Text(languageSpecificText(zhText: "支付密碼", enText: "Change payment password"))) {
                    Label(languageSpecificText(zhText: "支付密碼", enText: "Change payment password"), systemImage: "key.fill")
                }

                Toggle(isOn: $isFaceIDEnabled) {
                    Label(languageSpecificText(zhText: "面容/指紋登入", enText: "FaceID/TouchID login"), systemImage: "faceid")
                }
                .onChange(of: isFaceIDEnabled) { newValue in
                    if newValue {
                        authenticateUser()
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(languageSpecificText(zhText: "帳戶&安全", enText: "Account & Security"))
                    .font(.headline)
                    .bold()
            }
        }
        .listStyle(GroupedListStyle())
        .alert(item: $authenticationError) { error in
            Alert(title: Text("Authentication Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = languageSpecificText(zhText: "需要Face ID/Touch ID驗證啟用此功能", enText: "Face ID/Touch ID verification is required to enable this feature")

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
            authenticationError = AuthenticationError(message: error?.localizedDescription ?? languageSpecificText(zhText: "不支持生物识别", enText: "Biometrics not supported"))
        }
    }
    
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct AccountSecurityView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSecurityView()
    }
}
