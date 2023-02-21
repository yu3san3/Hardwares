//
//  Localize.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/02/22.
//

import Foundation

public class Localize {
    
    //文字列を投げると、空白に挟まれた部分の数字がローカライズされる
    public static func numbers(_ str: String) -> String {
        
        var result: String = ""
        
        let array: [String] = str.components(separatedBy: " ") //文字列を空白で分けた配列に変換
        for i in 0 ..< array.count {
            if let float = Float(array[i]) {
                //Flotへ変換できた場合
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let commaAdded: String = formatter.string(from: NSNumber(value: float))! //コンマを追加
                result.append(commaAdded)
            } else {
                //Floatへ変換できなかった場合は要素をそのまま追加する(単位などがこれにあたる)
                result.append(array[i])
            }
            result.append(" ")
        }
        
        return String(result.dropLast()) //最後の余分な空白を取り除いて返す
    }
    
    //yyyy/MM/ddの形式をローカライズする
    public static func date(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //ロケール設定(端末の暦設定に引きづられないようにする)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //タイムゾーン設定(端末設定によらず、どこの地域の時間帯なのかを指定する)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //いったんDate型に変換
        let releaseDate = formatter.date(from: dateStr)
        formatter.dateStyle = .long
        //ロケール設定を戻す
        formatter.locale = Locale(identifier: Locale.current.identifier)
        //Date型からString型に変換
        let releaseDateStr = formatter.string(from: releaseDate!)
        return releaseDateStr
    }
}
