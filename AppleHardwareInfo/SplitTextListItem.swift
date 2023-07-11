//
//  SplitTextListItem.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

struct SplitTextListItem: View {

    let title: LocalizedStringKey
    let element: String

    var body: some View {
        HStack {
            Text(title)
                .defaultStyle()
            Spacer()
            Text(element)
                .defaultStyle()
        }
    }
}

struct SplitTextListItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SplitTextListItem(title: "title", element: "element")
        }
    }
}
