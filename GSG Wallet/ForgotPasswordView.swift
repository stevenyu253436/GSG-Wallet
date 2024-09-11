//
//  ForgotPasswordView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/25.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
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
                Text("輸入驗證碼")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                HStack {
                    TextField("輸入驗證碼", text: $verificationCode)
                        .keyboardType(.numberPad)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        sendVerificationCode()
                    }) {
                        Text("獲取驗證碼")
                            .font(.subheadline)
                            .foregroundColor(.purple)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()
            
            Spacer()

            Button(action: {
                // 下一步操作
            }) {
                Text("下一步")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("忘記密碼")
    }
    
    // Function to send the verification code request
    func sendVerificationCode() {
        guard !phoneNumber.isEmpty else {
            print("Phone number is required")
            return
        }

        isLoading = true

        let url = URL(string: "https://gnugcc.ddns.net/api/BitoProServices/MobileSMS")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "mobile": phoneNumber
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Failed to encode JSON")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("Failed to send request: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: \(jsonResponse)")
                    // Handle the response data as needed
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
