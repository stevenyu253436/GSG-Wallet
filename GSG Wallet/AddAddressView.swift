import SwiftUI

struct AddAddressView: View {
    @State private var selectedCurrency = "請選擇幣名"
    @State private var selectedChain = "請選擇鏈名稱"
    @State private var address = ""
    @State private var recipient = ""

    let currencies = ["USDT"]
    let chains = ["ERC20", "TRC20"]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("幣名")) {
                    Picker("請選擇幣名", selection: $selectedCurrency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // 使用菜单样式的选择器
                }

                Section(header: Text("地址")) {
                    TextField("請輸入地址", text: $address)
                }

                Section(header: Text("鏈名稱")) {
                    Picker("請選擇鏈名稱", selection: $selectedChain) {
                        ForEach(chains, id: \.self) { chain in
                            Text(chain)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // 使用菜单样式的选择器
                }

                Section(header: Text("收款人")) {
                    TextField("請輸入收款人", text: $recipient)
                }
            }
            
            // 添加用户提示文本
            if address.isEmpty || selectedCurrency == "請選擇幣名" || selectedChain == "請選擇鏈名稱" || recipient.isEmpty {
                Text("請填寫所有必填項目").foregroundColor(.red)
                    .padding(.bottom, 10)
            }
            
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
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
            .disabled(address.isEmpty || selectedCurrency == "請選擇幣名" || selectedChain == "請選擇鏈名稱" || recipient.isEmpty) // 当任意字段为空时禁用按钮
        }
        .navigationTitle("添加地址")
    }
}

struct AddAddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddAddressView()
    }
}
