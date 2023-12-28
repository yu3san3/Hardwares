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
    @State private var textFieldContent: String
    let listItem: ListItem
    let okButtonAction: OkButtonAction

    init(alertTitle: LocalizedStringKey,
         alertMessage: LocalizedStringKey,
         textFieldPlaceholder: LocalizedStringKey,
         textFieldInitialValue textFieldContent: String,
         @ViewBuilder listItem: () -> ListItem,
         okButtonAction: @escaping OkButtonAction
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.textFieldPlaceholder = textFieldPlaceholder
        self._textFieldContent = State(initialValue: textFieldContent)
        self.listItem = listItem()
        self.okButtonAction = okButtonAction
    }

    typealias OkButtonAction = (String) -> Void

    @State private var isShowingAlert = false

    var body: some View {
        listItem
            .contentShape(Rectangle())
            .onTapGesture {
                isShowingAlert = true
            }
            .alert(alertTitle, isPresented: $isShowingAlert) {
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
