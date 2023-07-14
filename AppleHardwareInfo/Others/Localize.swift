//
//  Localize.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/02/22.
//

import Foundation

extension String {
    //文字列を投げると、空白に挟まれた部分の数字がローカライズされる
    public var localizedNumber: String {
        var localizedString: String = ""
        let components: [String] = self.components(separatedBy: " ") //文字列を空白で分けた配列に変換
        for component in components {
            if let float = Float(component) {
                //Flotへ変換できた場合
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedNumber: String = formatter.string(from: NSNumber(value: float) )!
                localizedString += formattedNumber
            } else {
                //Floatへ変換できなかった場合は要素をそのまま追加する(単位などがこれにあたる)
                localizedString += component
            }
            localizedString += " "
        }
        return localizedString.trimmingCharacters(in: .whitespaces) //最後の余分な空白を取り除いて返す
    }

    public var localizedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //ロケール設定(端末の暦設定に引きづられないようにする)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //タイムゾーン設定(端末設定によらず、どこの地域の時間帯なのかを指定する)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //いったんDate型に変換
        let releaseDate = formatter.date(from: self)
        formatter.dateStyle = .long
        //ロケール設定を戻す
        formatter.locale = Locale(identifier: Locale.current.identifier)
        //Date型からString型に変換
        let releaseDateStr = formatter.string(from: releaseDate!)
        return releaseDateStr
    }
}
