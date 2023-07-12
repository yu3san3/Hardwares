//
//  Battery.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

class Battery: ObservableObject {

    @AppStorage("revicedBatteryCapacityKey") var revisedCapacity: String = "default" //補正された容量
    @AppStorage("maximumBatteryCapacityKey") var maximumCapacity: String = "100 %" //最大容量

    //実際のバッテリー容量
    var actualCapacity: String {
        //文字列から要素を取得
        func getElement(_ str: String) -> Float? {
            let array: [String] = str.components(separatedBy: " ") //文字列を空白で分けた配列に変換
            return Float(array[0]) //要素のみを返す
        }

        guard let revisedCapacity: Float = getElement(revisedCapacity) else { //2000 mAh → 2000
            return "-"
        }
        guard let maximumCapacity: Float = getElement(maximumCapacity) else { //98 % → 98
            return "Error: Invalid Value."
        }
        let actualCapacity: Float = round(revisedCapacity * (maximumCapacity / 100)) //2000 * 0.98
        return String(actualCapacity) + " mAh"
    }

    init() {
        //初回起動時にバッテリー容量のデフォルト値を設定する
        if revisedCapacity == "default" {
            revisedCapacity = registeredCapacity
        }
    }

    //DeviceListに登録されている、currentDeviceのバッテリー容量
    private var registeredCapacity: String {
        if let index = Data.currentDeviceIndex {
            switch UIDevice.current.systemName {
            case OperatingSystem.iOS.rawValue:
                return DeviceData.iPhoneArray[index].batteryCapacity
            case OperatingSystem.iPadOS.rawValue:
                return DeviceData.iPadArray[index].batteryCapacity
            default:
                break
            }
        }
        return "unknown mAh"
    }
}
