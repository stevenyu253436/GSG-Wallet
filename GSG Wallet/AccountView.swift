//
//  AccountView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true // 默认是登录状态
    
    @State private var showMessageCenter = false
    @State private var showAlertType: AlertType? // 用于控制不同 alert 的显示
    @State private var showIdentityVerification = false // 控制身份认证页面的显示
    @State private var navigationPath = NavigationPath() // 用于 NavigationStack 的路径

    enum AlertType: Identifiable {
        case missingInfo
        case logoutConfirmation
        
        var id: Int {
            hashValue // 使 AlertType 符合 Identifiable 协议
        }
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) { // 使用 NavigationStack
            VStack {
                // 头像和基本信息部分
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 15) {
                        // 头像
                        ZStack {
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 60, height: 60)
                            
                            Text("CY")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("097****868")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text("Chewei Yu")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 添加操作代码
                        }) {
                            Image(systemName: "camera")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                // 列表部分
                List {
                    Section {
                        NavigationLink(destination: AccountSecurityView()) {
                            Label("帳戶&安全", systemImage: "person.crop.circle")
                        }
                        
                        NavigationLink(destination: IdentityVerificationView()) {
                            HStack {
                                Label("身份認證", systemImage: "checkmark.shield")
                                Spacer()
                                Text("待完善")
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                            }
                        }
                        
                        Button(action: {
                            showAlertType = .missingInfo // 点击帐户管理时触发 missingInfo 的 alert
                        }) {
                            HStack {
                                Label("帳戶管理", systemImage: "gear")
                                Spacer() // 在 Label 和箭头图标之间添加间隔
                                Image(systemName: "chevron.right") // 使用系统的向右箭头图标
                                    .foregroundColor(.gray) // 设置箭头的颜色
                            }
                        }
                        
                        NavigationLink(destination: AddressBookView()) {
                            Label("地址簿", systemImage: "bookmark")
                        }
                    }
                    
                    Section {
                        NavigationLink(destination: ServiceFeesView()) {
                            Label("服務費用", systemImage: "doc.text.magnifyingglass")
                        }
                        
                        NavigationLink(destination: InviteFriendsView()) {
                            Label("邀請好友", systemImage: "gift")
                        }
                        
                        NavigationLink(destination: Text("語言設定")) {
                            Label("語言設定", systemImage: "globe")
                        }
                        
                        NavigationLink(destination: Text("幫助")) {
                            Label("幫助", systemImage: "questionmark.circle")
                        }
                        
                        NavigationLink(destination: Text("關於Unioncash")) {
                            Label("關於GSG Wallet", systemImage: "exclamationmark.circle")
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                
                Spacer()
                
                Button(action: {
                    // 显示登出确认弹窗
                    showAlertType = .logoutConfirmation
                }) {
                    Text("登出")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("賬戶")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showMessageCenter.toggle()
                    }) {
                        Image(systemName: "bell")
                            .foregroundColor(.gray)
                    }
                    .background(
                        NavigationLink(
                            destination: MessageCenterView(),
                            isActive: $showMessageCenter,
                            label: { EmptyView() }
                        )
                    )
                }
            }
            .alert(item: $showAlertType) { alertType in
                switch alertType {
                case .missingInfo:
                    return Alert(
                        title: Text("提示"),
                        message: Text("您還沒有完善基本訊息，請先完善基本資訊。"),
                        primaryButton: .default(Text("確認")) {
                            // 使用路径导航到身份认证页面
                            navigationPath.append("IdentityVerification")
                        },
                        secondaryButton: .cancel(Text("取消"))
                    )
                case .logoutConfirmation:
                    return Alert(
                        title: Text("確認已登出嗎？"),
                        primaryButton: .destructive(Text("登出")) {
                            // 将 isLoggedIn 设置为 false, 退出到 LoginView
                            isLoggedIn = false
                        },
                        secondaryButton: .cancel(Text("取消"))
                    )
                }
            }
            // 在合适的位置添加 NavigationLink 控制身份认证页面的显示
            .background(
                NavigationLink(
                    destination: IdentityVerificationView(),
                    isActive: $showIdentityVerification,
                    label: { EmptyView() }
                )
            )
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "AccountSecurity":
                    AccountSecurityView()
                case "IdentityVerification":
                    IdentityVerificationView()
                case "AddressBook":
                    Text("地址簿")
                case "ServiceFees":
                    Text("服務費用")
                case "InviteFriends":
                    InviteFriendsView() // 改这里
                case "LanguageSettings":
                    Text("語言設定")
                case "Help":
                    Text("幫助")
                case "AboutUnioncash":
                    Text("關於GSG Wallet")
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
