//
//  BatteryCorrectionListItem.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/13.
//

import SwiftUI

struct BatteryCorrectionListItem: View {

    let type: CorrectionType

    enum CorrectionType {
        case revisedCapacity
        case maximumCapacity
    }

    private let title: LocalizedStringKey
    private var element: String {
        switch type {
        case .revisedCapacity:
            return battery.revisedCapacity
        case .maximumCapacity:
            return battery.maximumCapacity
        }
    }

    private let placeholder: LocalizedStringKey

    init(type: CorrectionType) {
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

    @State private var isShowingAlert: Bool = false
    @State private var textFieldContent: String = ""

    @ObservedObject var battery = Battery()

    var body: some View {
        HStack {
            Text(title)
                .defaultStyle()
            Spacer()
            Text(Localize.numbers(element))
                .defaultStyle()
            Image(systemName: "chevron.forward") //Disclosure Indicator(>)
                .font(Font.system(.caption).weight(.bold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            let array: [String] = element.components(separatedBy: " ")
            textFieldContent = String(array[0])
            self.isShowingAlert = true
        }
        .alert(
            "\(title.toString())の補正",
            isPresented: $isShowingAlert,
            actions: {
                TextField(placeholder, text: $textFieldContent)
                    .keyboardType(.numberPad)
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
                    switch type {
                    case .revisedCapacity:
                        battery.revisedCapacity = textFieldContent + " mAh"
                    case .maximumCapacity:
                        battery.maximumCapacity = textFieldContent + " %"
                    }
                }
                Button("キャンセル", role: .cancel) {}
            }, message: {
                Text("現在の値: \(Localize.numbers(element))")
            }
        )
    }
}

struct BatteryCorrectionListItem_Previews: PreviewProvider {
    static var previews: some View {
        BatteryCorrectionListItem(type: .revisedCapacity)
    }
}
