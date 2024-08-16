//
//  IdentityVerificationView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct IdentityVerificationView: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text("個人資訊")) {
                    HStack {
                        Label("個人資訊", systemImage: "person.fill")
                        Spacer()
                        Text("審核中")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }

                NavigationLink(destination: Text("護照")) {
                    HStack {
                        Label("護照", systemImage: "doc.fill")
                        Spacer()
                        Text("待完善")
                            .foregroundColor(.orange)
                            .font(.subheadline)
                    }
                }

                NavigationLink(destination: Text("人臉辨識")) {
                    HStack {
                        Label("人臉辨識", systemImage: "faceid")
                        Spacer()
                        Text("審核中")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationTitle("身份認證")
        .listStyle(GroupedListStyle())
    }
}

struct IdentityVerificationView_Previews: PreviewProvider {
    static var previews: some View {
        IdentityVerificationView()
    }
}
