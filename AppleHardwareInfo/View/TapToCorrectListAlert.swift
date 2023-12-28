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
    let listItem: ListItem

    init(alertTitle: LocalizedStringKey,
         alertMessage: LocalizedStringKey,
         @ViewBuilder listItem: () -> ListItem
    ) {
        self.alertTitle = alertTitle
        self.alertMessage = alertMessage
        self.listItem = listItem()
    }

    @State private var isShowingAlert = false

    var body: some View {
        listItem
            .onTapGesture {
                isShowingAlert = true
            }
            .alert(alertTitle, isPresented: $isShowingAlert) {
                Button("OK") {

                }
                Button("キャンセル", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
    }
}

#Preview {
    TapToCorrectListAlert(alertTitle: "Hello",
                       alertMessage: "This is the test alert."
    ) {
        Text("Hello")
    }
}
