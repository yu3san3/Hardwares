//
//  BatteryCorrectionListItem.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/13.
//

import SwiftUI

struct BatteryCorrectionListItem: View {
    @ObservedObject var battery = Battery()

    let type: BatteryCorrectionType

    private let title: LocalizedStringKey
    private let placeholder: LocalizedStringKey

    private var element: String {
        switch type {
        case .revisedCapacity:
            if let revisedCapacity = battery.revisedCapacity {
                return "\(revisedCapacity) \(battery.revisedCapacityUnit)"
            } else {
                //revisedCapacityがnilの場合の表示
                return "unknown \(battery.revisedCapacityUnit)"
            }
        case .maximumCapacity:
            return "\(battery.maximumCapacity) \(battery.maximumCapacityUnit)"
        }
    }

    @State private var isShowingAlert: Bool = false
    @State private var textFieldContent: String = ""

    init(type: BatteryCorrectionType) {
        self.type = type

        switch type {
        case .revisedCapacity:
            self.title = "容量"
            self.placeholder = "0 mAh"
        case .maximumCapacity:
            self.title = "最大容量"
            self.placeholder = "100 %"
        }
    }

    var body: some View {
        listItem
            .contentShape(Rectangle())
            .onTapGesture {
                textFieldContent = element.firstComponents!
                isShowingAlert = true
            }
            .alert(
                "\(title.toString())の補正",
                isPresented: $isShowingAlert,
                actions: {
                    alertTextField
                    alertOkButton
                    alertCancelButton
                },
                message: {
                    Text("現在の値: \(element.localizedNumber)")
                }
            )
    }
}

private extension BatteryCorrectionListItem {
    var listItem: some View {
        HStack {
            Text(title)
                .defaultStyle()
            Spacer()
            Text(element.localizedNumber)
                .defaultStyle()
            Image(systemName: "chevron.forward") //Disclosure Indicator(>)
                .font(Font.system(.caption).weight(.bold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
    }

    var alertTextField: some View {
        TextField(placeholder, text: $textFieldContent)
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
    }

    var alertOkButton: some View {
        Button("OK") {
            switch type {
            case .revisedCapacity:
                if let textFieldDouble = Double(textFieldContent) {
                    battery.revisedCapacity = textFieldDouble
                } else {
                    print("Error: Cannot convert String into Double")
                }
            case .maximumCapacity:
                if let textFieldInt = Int(textFieldContent) {
                    battery.maximumCapacity = textFieldInt
                } else {
                    print("Error: Cannot convert String into Int")
                }
            }
        }
    }

    var alertCancelButton: some View {
        Button("キャンセル", role: .cancel) {}
    }
}

private extension String {
    var firstComponents: String? {
        let components: [String] = self.components(separatedBy: " ")
        return components.first
    }
}

struct BatteryCorrectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        BatteryCorrectionListItem(type: .revisedCapacity)
    }
}
