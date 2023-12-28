//
//  TapToEditListAlert.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/12/28.
//

import SwiftUI

struct TapToCorrectListAlert<ListItem: View>: View {
    let alertTitle: LocalizedStringKey
    let alertMessage: LocalizedStringKey
    let textFieldPlaceholder: LocalizedStringKey
    let textFieldInitialValue: String
    let listItem: ListItem
    let okButtonAction: OkButtonAction

    init(alertTitle: LocalizedStringKey,
         alertMessage: LocalizedStringKey,
         textFieldPlaceholder: LocalizedStringKey,
         textFieldInitialValue: String,
         @ViewBuilder listItem: () -> ListItem,
         okButtonAction: @escaping OkButtonAction
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldInitialValue = textFieldInitialValue
        self.listItem = listItem()
        self.okButtonAction = okButtonAction
    }

    typealias OkButtonAction = (String) -> Void

    @State private var isShowingAlert = false
    @State private var textFieldContent = ""

    var body: some View {
        HStack {
            listItem
            Spacer()
            Image(systemName: "chevron.forward") //Disclosure Indicator(>)
                .font(Font.system(.caption).weight(.bold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            //cancelボタンでalertがdismissされた場合でも、正しくtextFieldContentの
            //内容が保持されるよう、ここで初期値を代入
            textFieldContent = textFieldInitialValue
            isShowingAlert = true
        }
        .alert(alertTitle, isPresented: $isShowingAlert) {
            //???: 謎のエラーが出る。しかも意図せずalertがdismissされる。
            //-[RTIInputSystemClient remoteTextInputSessionWithID:performInputOperation:]  perform input operation requires a valid sessionID
            TextField(textFieldPlaceholder, text: $textFieldContent)
                .keyboardType(.decimalPad)
                .onReceive( //テキストを全選択
                    NotificationCenter.default.publisher(
                        for: UITextField.textDidBeginEditingNotification
                    )
                ) { obj in
                    if let textField = obj.object as? UITextField {
                        textField.selectedTextRange = textField.textRange(
                            from: textField.beginningOfDocument,
                            to: textField.endOfDocument
                        )
                    }
                }
            Button("OK") {
                okButtonAction(textFieldContent)
            }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    TapToCorrectListAlert(alertTitle: "Hello",
                          alertMessage: "This is the test alert.",
                          textFieldPlaceholder: "This is the placeholder.",
                          textFieldInitialValue: "initial Value"
    ) {
        Text("Hello")
    } okButtonAction: { textFieldContent in
        print("OK Button Tapped! The TextField Content is \(textFieldContent)")
    }
}
