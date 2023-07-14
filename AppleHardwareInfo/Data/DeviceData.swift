//
//  DeviceData.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI

extension DeviceData {
    //デバイス名のみの配列を作る
    static let iPhoneNameArray = DeviceData.iPhoneArray.map({ (list) -> String in
        return list.deviceName
    })
    static let iPadNameArray = DeviceData.iPadArray.map({ (list) -> String in
        return list.deviceName
    })
}

extension DeviceData {
    static func getCurrentDeviceData() -> DeviceData? {
        guard let index = getIndexOfCurrentDeviceInDeviceArray() else {
            return nil
        }
        switch UIDevice.current.systemName {
        case OperatingSystem.iOS.rawValue:
            return DeviceData.iPhoneArray[index]
        case OperatingSystem.iPadOS.rawValue:
            return DeviceData.iPadArray[index]
        default:
            return nil
        }
    }

    //deviceDataのArrayにおけるcurrentDeviceのindex
    private static func getIndexOfCurrentDeviceInDeviceArray() -> Int? {
        switch UIDevice.current.systemName {
        case OperatingSystem.iOS.rawValue:
            return DeviceData.iPhoneNameArray.firstIndex(of: YMTGetDeviceName.getDeviceName())
        case OperatingSystem.iPadOS.rawValue:
            return DeviceData.iPadNameArray.firstIndex(of: YMTGetDeviceName.getDeviceName())
        default:
            return nil
        }
    }
}

struct DeviceData: Identifiable {
    var id = UUID()
    var deviceName: String //端末名
    var chip: String //チップ
    var memoryCapacity: String //メモリ容量
    var dispInch: String //画面インチ数
    var dispResolution: String //画面解像度
    var dispPpi: String //画面ppi
    var rearCam: [String:String] //背面カメラ
    var frontCam: [String:String] //前面カメラ
    var weight: String //重量
    var battery: (capacity: Double, unit: BatteryCapacityUnit) //バッテリー容量
    var releaseDate: String //発売日
    var technicalSpecificationsUrl: String //技術仕様リンク
}

extension DeviceData {
    static let iPhoneArray = [
        //DeviceData(deviceName: "", chip: "", memoryCapacity: " GB",  dispInch: " inch ()", dispResolution: " x  pixel", dispPpi: " ppi",rearCam: ["wide":" MP f/","ultraWide":" MP f/","tele":" MP f/"], frontCam: ["wide":" MP f/"], weight: " g", batteryCapacity: " mAh", releaseDate: "", technicalSpecificationsUrl: ""),
        DeviceData(deviceName: "iPhone 12 Pro Max", chip: "A14 Bionic", memoryCapacity: "6 GB",  dispInch: "6.7 inch (OLED)", dispResolution: "2778 x 1284 pixel", dispPpi: "458 ppi",rearCam: ["wide":"12 MP, f/1.6","ultraWide":"12 MP, f/2.4","tele":"12 MP, f/2.2"], frontCam: ["wide":"12 MP, f/2.2"], weight: "226 g", battery: (capacity: 3687, unit: .mAh), releaseDate: "2020/11/13", technicalSpecificationsUrl: "kb/SP832"),
        DeviceData(deviceName: "iPhone 12 Pro", chip: "A14 Bionic", memoryCapacity: "6 GB",  dispInch: "6.1 inch (OLED)", dispResolution: "2532 x 1170 pixel", dispPpi: "460 ppi",rearCam: ["wide":"12 MP, f/1.6","ultraWide":"12 MP, f/2.4","tele":"12 MP, f/2.0"], frontCam: ["wide":"12 MP, f/2.2"], weight: "187 g", battery: (capacity: 2775, unit: .mAh), releaseDate: "2020/10/23", technicalSpecificationsUrl: "kb/SP831"),
        DeviceData(deviceName: "iPhone 12", chip: "A14 Bionic", memoryCapacity: "4 GB",  dispInch: "6.1 inch (OLED)", dispResolution: "2532 x 1170 pixel", dispPpi: "460 ppi",rearCam: ["wide":"12 MP, f/1.6","ultraWide":"12 MP, f/2.4"], frontCam: ["wide":"12 MP, f/2.2"], weight: "162 g", battery: (capacity: 2775, unit: .mAh), releaseDate: "2020/10/23", technicalSpecificationsUrl: "kb/SP830"),
        DeviceData(deviceName: "iPhone 12 mini", chip: "A14 Bionic", memoryCapacity: "4 GB",  dispInch: "5.4 inch (OLED)", dispResolution: "2340 x 1080 pixel", dispPpi: "476 ppi",rearCam: ["wide":"12 MP, f/1.6","ultraWide":"12 MP, f/2.4"],frontCam: ["wide":"12 MP, f/2.2"], weight: "133 g", battery: (capacity: 2227, unit: .mAh), releaseDate: "2020/11/13", technicalSpecificationsUrl: "kb/SP829"),
        DeviceData(deviceName: "iPhone 8", chip: "A11 Bionic", memoryCapacity: "2 GB",  dispInch: "4.7 inch (IPS)", dispResolution: "1334 x 750 pixel", dispPpi: "326 ppi",rearCam: ["wide":"12 MP, f/1.8"], frontCam: ["wide":"7 MP, f/2.2"], weight: "148 g", battery: (capacity: 1821, unit: .mAh), releaseDate: "2017/09/22", technicalSpecificationsUrl: "kb/SP767"),
        DeviceData(deviceName: "iPhone 7", chip: "A10 Fusion", memoryCapacity: "2 GB (LPDDR4)",  dispInch: "4.7 inch (IPS)", dispResolution: "1334 x 750 pixel", dispPpi: "326 ppi",rearCam: ["wide":"12 MP, f/1.8"], frontCam: ["wide":"7 MP, f/2.2"], weight: "138 g", battery: (capacity: 1960, unit: .mAh), releaseDate: "2016/09/16", technicalSpecificationsUrl: "kb/SP743"),
        DeviceData(deviceName: "iPhone 5s", chip: "A7", memoryCapacity: "1 GB (LPDDR3)",  dispInch: "4 inch (IPS)", dispResolution: "1136 x 640 pixel", dispPpi: "326 ppi",rearCam: ["wide":"8 MP, f/2.2"], frontCam: ["wide":"1.2 MP, f/2.4"], weight: "112 g", battery: (capacity: 1560, unit: .mAh), releaseDate: "2013/09/20", technicalSpecificationsUrl: "kb/sp685"),
    ]

    static let iPadArray = [
        DeviceData(deviceName: "iPad mini (6th generation)", chip: "A15 Bionic (5-GPU)", memoryCapacity: "4 GB",  dispInch: "8.3 inch (IPS)", dispResolution: "2,266 x 1,488 pixel", dispPpi: "326 ppi", rearCam: ["wide":"12 MP, f/1.8"], frontCam: ["ultraWide":"12 MP, f/2.2"], weight: "293 g (Cellular: 297 g)", battery: (capacity: 19.3, unit: .Wh), releaseDate: "2021/09/24", technicalSpecificationsUrl: "kb/SP850"),
    ]
}
