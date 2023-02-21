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
    public func toString() -> String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        
        //key属性の値を探す
        let attributeLabelAndValue = mirror.children.first { (arg0) -> Bool in
            let (label, _) = arg0
            if(label == "key"){
                return true;
            }
            return false;
        }
        
        if(attributeLabelAndValue != nil) {
            //NSLocalizedStringを介して、見つかったkeyのローカライズを要求する
            return String.localizedStringWithFormat(
                NSLocalizedString(
                    attributeLabelAndValue!.value as! String,
                    comment: ""
                )
            );
        }
        else {
            return "Swift LocalizedStringKey signature must have changed."
        }
    }
}
