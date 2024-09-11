//
//  IdentityVerificationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct IdentityVerificationView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"

    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text(languageSpecificText(zhText: "個人資訊", enText: "Personal information"))) {
                    HStack {
                        Label(languageSpecificText(zhText: "個人資訊", enText: "Personal information"), systemImage: "person.fill")
                        Spacer()
                        Text(languageSpecificText(zhText: "審核中", enText: "Reviewing"))
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }

                NavigationLink(destination: Text(languageSpecificText(zhText: "護照", enText: "Passport"))) {
                    HStack {
                        Label(languageSpecificText(zhText: "護照", enText: "Passport"), systemImage: "doc.fill")
                        Spacer()
                        Text(languageSpecificText(zhText: "待完善", enText: "Incomplete"))
                            .foregroundColor(.orange)
                            .font(.subheadline)
                    }
                }

                NavigationLink(destination: Text(languageSpecificText(zhText: "人臉辨識", enText: "Face identification"))) {
                    HStack {
                        Label(languageSpecificText(zhText: "人臉辨識", enText: "Face identification"), systemImage: "faceid")
                        Spacer()
                        Text(languageSpecificText(zhText: "審核中", enText: "Reviewing"))
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(languageSpecificText(zhText: "身份認證", enText: "Identity authentication"))
                    .font(.headline)
                    .bold()
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct IdentityVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityVerificationView()
    }
}
