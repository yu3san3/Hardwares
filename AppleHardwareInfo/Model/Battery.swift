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
            setupInitialRevisedCapacityUnit()
            return
        }
        //初回起動時にバッテリー容量のデフォルト値を設定する
        if self.revisedCapacity == nil {
            self.revisedCapacity = currentDeviceData.battery.capacity
        }
        self.revisedCapacityUnit = currentDeviceData.battery.unit.rawValue
    }

    private func setupInitialRevisedCapacityUnit() {
        //現在使用中のOSによってrevisedCapacityUnitの初期値を変える
        switch UIDevice.current.systemName {
        case OperatingSystem.iOS.rawValue:
            self.revisedCapacityUnit = BatteryCapacityUnit.mAh.rawValue
        case OperatingSystem.iPadOS.rawValue:
            self.revisedCapacityUnit = BatteryCapacityUnit.Wh.rawValue
        default:
            break
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
