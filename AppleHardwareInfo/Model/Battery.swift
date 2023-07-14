//
//  Battery.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

class Battery: ObservableObject {

    @AppStorage("revisedBatteryCapacity") var revisedCapacity: Double? //補正された容量
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
    func calculateActualCapacity() -> Double? {
        guard let revisedCapacity = self.revisedCapacity else {
            return nil
        }
        let maximumDouble = Double(maximumCapacity)
        let actualCapacity: Double = revisedCapacity * (maximumDouble / 100) //2000(mAh) * 0.98
        return actualCapacity
    }
}
