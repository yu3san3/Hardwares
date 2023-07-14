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
            print("Error: Current device data is not registered")
            let initialUnit = getInitialCapacityUnit()
            self.revisedCapacityUnit = initialUnit!.rawValue
            return
        }
        //初回起動時にバッテリー容量のデフォルト値を設定する
        if self.revisedCapacity == nil {
            self.revisedCapacity = currentDeviceData.battery.capacity
        }
        self.revisedCapacityUnit = currentDeviceData.battery.unit.rawValue
    }

    func getInitialCapacityUnit() -> BatteryCapacityUnit? {
        //現在使用中のOSによってrevisedCapacityUnitの初期値を変える
        switch UIDevice.current.systemName {
        case OperatingSystem.iOS.rawValue:
            return BatteryCapacityUnit.mAh
        case OperatingSystem.iPadOS.rawValue:
            return BatteryCapacityUnit.Wh
        default:
            break
        }
        return nil
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
