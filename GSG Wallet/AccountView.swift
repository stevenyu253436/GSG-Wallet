//
//  AccountView.swift
//  GSG Wallet
//
//  Created by 游哲維 on 2024/8/16.
//

import SwiftUI

let selectedLanguageKey = "selectedLanguage"

struct AccountView: View {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true // 默认是登录状态
    @AppStorage(selectedLanguageKey) var selectedLanguage: String = "zh-Hant"

    @State private var showMessageCenter = false
    @State private var showAlertType: AlertType? // 用于控制不同 alert 的显示
    @State private var showIdentityVerification = false // 控制身份认证页面的显示
    @State private var navigationPath = NavigationPath() // 用于 NavigationStack 的路径
    @State private var showHelpSheet = false // 控制帮助视图的显示
    @State private var showCameraActionSheet = false // 控制相机选项的显示

    @State private var showImagePicker = false // 控制 ImagePicker 的显示
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .camera // 控制图片选择的来源
    @State private var selectedImage: UIImage? // 保存选择的图片
    @State private var showLanguageSheet = false // 控制语言选择视图的显示
    @State private var navigateToIdentityVerification = false

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
                UserInfoView()  // 将复杂的部分提取为单独的视图
                
                // 列表部分
                List {
                    Section {
                        NavigationLink(destination: AccountSecurityView()) {
                            Label(languageSpecificText(zhText: "帳戶&安全", enText: "Account & Security"), systemImage: "person.crop.circle")
                                .padding(.vertical, 6) // Increase vertical padding
                        }
                        
                        NavigationLink(destination: IdentityVerificationView()) {
                            HStack {
                                Label(languageSpecificText(zhText: "身份認證", enText: "Identity authentication"), systemImage: "checkmark.shield")
                                Spacer()
                                Text(languageSpecificText(zhText: "待完善", enText: "Incomplete"))
                                    .foregroundColor(.orange)
                                    .font(.subheadline)
                            }
                            .padding(.vertical, 6) // Increase vertical padding
                        }
                        
                        Button(action: {
                            showAlertType = .missingInfo // 点击帐户管理时触发 missingInfo 的 alert
                        }) {
                            HStack {
                                Label {
                                    Text(languageSpecificText(zhText: "帳戶管理", enText: "Account management"))
                                        .foregroundColor(.black) // Set the text color to black
                                } icon: {
                                    Image(systemName: "gear")
                                }
                                
                                Spacer() // 在 Label 和箭头图标之间添加间隔
                                
                                Image(systemName: "chevron.right") // 使用系统的向右箭头图标
                                    .foregroundColor(.gray) // 设置箭头的颜色
                            }
                            .padding(.vertical, 6) // Increase vertical padding
                        }
                        
                        NavigationLink(destination: AddressBookView()) {
                            Label(languageSpecificText(zhText: "地址簿", enText: "Address book"), systemImage: "bookmark")
                                .padding(.vertical, 6) // Increase vertical padding
                        }
                        
                        NavigationLink(destination: ServiceFeesView()) {
                            Label(languageSpecificText(zhText: "服務費用", enText: "Service fee"), systemImage: "doc.text.magnifyingglass")
                                .padding(.vertical, 6) // Increase vertical padding
                        }
                            
                        Button(action: {
                            showLanguageSheet.toggle() // 显示语言选择视图
                        }) {
                            HStack {
                                Label {
                                    Text(languageSpecificText(zhText: "語言設定", enText: "Language setting"))
                                        .foregroundColor(.black) // Set the text color to black
                                } icon: {
                                    Image(systemName: "globe")
                                }
                                
                                Spacer() // Add some space between the text and the chevron
                                Image(systemName: "chevron.right") // Add the chevron icon
                                    .foregroundColor(.gray) // You can set the color of the chevron here
                            }
                            .padding(.vertical, 6) // Increase vertical padding
                        }

                        Button(action: {
                            showHelpSheet.toggle() // 显示帮助视图
                        }) {
                            HStack {
                                Label {
                                    Text(languageSpecificText(zhText: "幫助", enText: "Help"))
                                        .foregroundColor(.black) // Set the text color to black
                                } icon: {
                                    Image(systemName: "questionmark.circle")
                                }
                                .padding(.vertical, 6) // Increase vertical padding

                                Spacer() // Add space between the label and the chevron

                                Image(systemName: "chevron.right") // Add the chevron icon
                                    .foregroundColor(.gray) // Set the color of the chevron to gray
                            }
                        }
                            
                        NavigationLink(destination: AboutView()) {
                            Label(languageSpecificText(zhText: "關於GSG Wallet", enText: "About GSG Wallet"), systemImage: "exclamationmark.circle")
                                .padding(.vertical, 6) // Increase vertical padding
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                                
                // Example usage of if-else navigation
                NavigationLink(destination: IdentityVerificationView(), isActive: $navigateToIdentityVerification) {
                    EmptyView()
                }
                .hidden() // Keep it hidden in the UI
                
                Button(action: {
                    // 显示登出确认弹窗
                    showAlertType = .logoutConfirmation
                }) {
                    Text(languageSpecificText(zhText: "登出", enText: "Log out"))
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
            .navigationTitle(languageSpecificText(zhText: "賬戶", enText: "Account"))
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
                        title: Text(languageSpecificText(zhText: "提示", enText: "Warning")),
                        message: Text(languageSpecificText(zhText: "您還沒有完善基本訊息，請先完善基本資訊。", enText: "You have not completed the basic information, please complete it first.")),
                        primaryButton: .default(Text(languageSpecificText(zhText: "確認", enText: "Confirm"))) {
                            navigateToIdentityVerification = true // Activate NavigationLink
                        },
                        secondaryButton: .cancel(Text(languageSpecificText(zhText: "取消", enText: "Cancel")))
                    )
                case .logoutConfirmation:
                    return Alert(
                        title: Text(languageSpecificText(zhText: "確認已登出嗎？", enText: "Are you sure you want to log out?")),
                        primaryButton: .destructive(Text(languageSpecificText(zhText: "登出", enText: "Log out"))) {
                            // 将 isLoggedIn 设置为 false, 退出到 LoginView
                            isLoggedIn = false
                        },
                        secondaryButton: .cancel(Text(languageSpecificText(zhText: "取消", enText: "Cancel")))
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
            .sheet(isPresented: $showHelpSheet) {
                HelpView() // 弹出 HelpView
            }
            .actionSheet(isPresented: $showLanguageSheet) {
                ActionSheet(
                    title: Text(languageSpecificText(zhText: "語言", enText: "Language")),
                    buttons: [
                        .default(Text(selectedLanguage == "zh-Hant" ? "繁體中文 ✅" : "繁體中文")) {
                            switchLanguage(to: "zh-Hant")
                        },
                        .default(Text(selectedLanguage == "en" ? "English ✅" : "English")) {
                            switchLanguage(to: "en")
                        },
                        .cancel(Text(languageSpecificText(zhText: "取消", enText: "Cancel")))
                    ]
                )
            }
            .confirmationDialog(languageSpecificText(zhText: "選擇操作", enText: "Choose an action"), isPresented: $showCameraActionSheet) {
                Button(languageSpecificText(zhText: "拍照", enText: "Camera")) {
                    imagePickerSourceType = .camera
                    showImagePicker = true
                }
                Button(languageSpecificText(zhText: "相簿", enText: "Album")) {
                    imagePickerSourceType = .photoLibrary
                    showImagePicker = true
                }
                Button(languageSpecificText(zhText: "取消", enText: "Cancel"), role: .cancel) { }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: imagePickerSourceType, selectedImage: $selectedImage)
            }
        }
    }
    
    private func switchLanguage(to languageCode: String) {
        selectedLanguage = languageCode
        Localizable.setLanguage(languageCode)
        // 手动刷新视图
//        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: AccountView())
    }
    
    // 一个辅助方法，用于根据当前语言选择显示的文本
    private func languageSpecificText(zhText: String, enText: String) -> String {
        return selectedLanguage == "zh-Hant" ? zhText : enText
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

// ImagePicker: 用于选择图片
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
