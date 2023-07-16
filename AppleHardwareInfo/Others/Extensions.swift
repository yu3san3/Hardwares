//
//  Extensions.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/02/22.
//

import SwiftUI

extension Text {
    //このアプリで用いる標準的なテキスト形式をdefaultStyleとして定義
    func defaultStyle() -> some View {
        self.font(.system(.callout, design: .rounded))
    }
}

extension LocalizedStringKey {
    //ローカライズされた値を返す
    public var toString: String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        //key属性の値を探す
        guard let attributeLabelAndValue = mirror.children.first(where: { $0.label == "key" }) else {
            return "Swift LocalizedStringKey signature must have changed."
        }
        //NSLocalizedStringを介して、見つかったkeyのローカライズを要求する
        return String.localizedStringWithFormat(
            NSLocalizedString(
                String(describing: attributeLabelAndValue.value),
                comment: ""
            )
        );
    }
}
