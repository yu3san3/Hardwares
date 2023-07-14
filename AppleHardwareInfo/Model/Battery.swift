//
//  Battery.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

class Battery: ObservableObject {

    @AppStorage("revisedBatteryCapacity") var revisedCapacity: Int? //補正された容量
    @AppStorage("revisedBatteryCapacityUnit") var revisedCapacityUnit = ""
    @AppStorage("maximumBatteryCapacity") var maximumCapacity = 100 //最大容量
    let maximumCapacityUnit = "%"

    init() {
        guard let currentDeviceData = DeviceData.getCurrentDeviceData() else {
            print("Unknown device")
            return
        }
        //初回起動時にバッテリー容量のデフォルト値を設定する
        if self.revisedCapacity == nil {
            self.revisedCapacity = currentDeviceData.battery.capacity
        }
        if self.revisedCapacityUnit.isEmpty {
            self.revisedCapacityUnit = currentDeviceData.battery.unit.rawValue
        }
    }

    //実際のバッテリー容量
    func calculateActualCapacity() -> Int? {
        guard let revisedCapacity = self.revisedCapacity else {
            return nil
        }
        let revisedDouble = Double(revisedCapacity)
        let maximumDouble = Double(maximumCapacity)
        let actualCapacity: Double = revisedDouble * (maximumDouble / 100) //2000 * 0.98
        return Int(actualCapacity) //Double -> Intの変換で、小数点以下は切り捨てている
    }
}
