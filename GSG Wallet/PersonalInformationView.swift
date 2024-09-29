//
//  PersonalInformationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/9/29.
//

import Foundation
import SwiftUI

var globalFirstName: String = "Chewei"
var globalLastName: String = "Yu"

struct PersonalInformationView: View {
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"
    
    @State private var firstName = "Chewei" // Sample first name
    @State private var lastName = "Yu" // Sample last name
    @State private var birthdate = Date()
    @State private var nationality = "中国台湾"
    @State private var residenceCountry = "中国台湾"
    @State private var residenceCity = "新竹市"
    @State private var addressDetail = "東區八德路19巷29號11樓29"
    @State private var postalCode = "300031"
    
    var body: some View {
        List {
            Section(header: Text(languageSpecificText(zhText: "名(英文或拼音)", enText: "First Name"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                Text(globalFirstName)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            
            Section(header: Text(languageSpecificText(zhText: "姓(英文或拼音)", enText: "Last Name"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                Text(globalLastName)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            
            Section(header:                     Text(languageSpecificText(zhText: "出生日期", enText: "Birthdate"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                Text(birthdate, style: .date)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
            
            Section(header:                    Text(languageSpecificText(zhText: "國籍", enText: "Nationality"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                HStack {
                    Text(nationality)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section(header:                     Text(languageSpecificText(zhText: "居住國家", enText: "Residence Country"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                HStack {
                    Text(residenceCountry)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section(header:                    Text(languageSpecificText(zhText: "居住城市", enText: "Residence City"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                HStack {
                    Text(residenceCity)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section(header:                     Text(languageSpecificText(zhText: "街道、鎮、村莊等詳細地址", enText: "Detailed Address"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                HStack {
                    Text(addressDetail)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            
            Section(header:                     Text(languageSpecificText(zhText: "居住城市郵編", enText: "Postal Code"))
                .font(.headline) // You can adjust the font style if needed
                .foregroundColor(.primary) // Set the color for the header text
            ) {
                Text(postalCode)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
            }
        }
        .navigationTitle(languageSpecificText(zhText: "個人資訊", enText: "Personal Information"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct PersonalInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInformationView()
    }
}
