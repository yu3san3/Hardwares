//
//  DeviceData.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI

extension DeviceData {
    //デバイス名のみの配列を作る
    static let iPhoneNameArray = DeviceData.iPhoneArray.map{ $0.deviceName }
    static let iPadNameArray = DeviceData.iPadArray.map{ $0.deviceName }
}

extension DeviceData {
    static func getCurrentDeviceData() -> DeviceData? {
        //実行中のデバイス名(iPhone 12 mini etc.)を取得
        let currentDeviceName = DeviceName.getCurrentDevice()
        var result: DeviceData?
        //systemName(iOS, iPadOS...)で場合分け
        switch UIDevice.current.systemName {
        case OperatingSystem.iOS.rawValue:
            //deviceNameと実行中のデバイス名が一致した初めての配列を結果に代入
            result = DeviceData.iPhoneArray.first { $0.deviceName == currentDeviceName }
        case OperatingSystem.iPadOS.rawValue:
            result = DeviceData.iPadArray.first { $0.deviceName == currentDeviceName }
        default:
            break
        }
        return result
    }
}

struct DeviceData: Identifiable {
    var id = UUID()
    var deviceName: String //端末名
    var chip: ChipData //チップ
    var memoryCapacity: String //メモリ容量
    var dispInch: String //画面インチ数
    var dispResolution: String //画面解像度
    var dispPpi: String //画面ppi
    var rearCam: [Camera: String] //背面カメラ
    var frontCam: [Camera: String] //前面カメラ
    var weight: String //重量
    var battery: (capacity: Double, unit: BatteryCapacityUnit) //バッテリー容量
    var releaseDate: String //発売日
    var technicalSpecificationsUrl: String //技術仕様リンク
}

extension DeviceData {
    static let iPhoneArray = [
        //DeviceData(deviceName: <#String#>, chip: <#ChipData#>, memoryCapacity: "<#String#> GB",  dispInch: "<#String#> inch (<#String#>)", dispResolution: "<#String#> x <#String#> pixel", dispPpi: "<#String#> ppi",rearCam: [.wide: "<#String#> MP f/<#String#>", .ultraWide: "<#String#> MP f/<#String#>", .tele: "<#String#> MP f/<#String#>"], frontCam: [.wide: "<#String#> MP f/<#String#>"], weight: "<#String#> g", battery: <#(capacity: Double, unit: BatteryCapacityUnit)#>, releaseDate: <#String#>, technicalSpecificationsUrl: <#String#>),
        DeviceData(deviceName: "iPhone 12 Pro Max", chip: Chip.a14Bionic.data, memoryCapacity: "6 GB",  dispInch: "6.7 inch (OLED)", dispResolution: "2778 x 1284 pixel", dispPpi: "458 ppi",rearCam: [.wide: "12 MP, f/1.6", .ultraWide: "12 MP, f/2.4", .tele: "12 MP, f/2.2"], frontCam: [.wide: "12 MP, f/2.2"], weight: "226 g", battery: (capacity: 3687, unit: .mAh), releaseDate: "2020/11/13", technicalSpecificationsUrl: "kb/SP832"),
        DeviceData(deviceName: "iPhone 12 Pro", chip: Chip.a14Bionic.data, memoryCapacity: "6 GB",  dispInch: "6.1 inch (OLED)", dispResolution: "2532 x 1170 pixel", dispPpi: "460 ppi", rearCam: [.wide: "12 MP, f/1.6", .ultraWide: "12 MP, f/2.4", .tele: "12 MP, f/2.0"], frontCam: [.wide: "12 MP, f/2.2"], weight: "187 g", battery: (capacity: 2775, unit: .mAh), releaseDate: "2020/10/23", technicalSpecificationsUrl: "kb/SP831"),
        DeviceData(deviceName: "iPhone 12", chip: Chip.a14Bionic.data, memoryCapacity: "4 GB",  dispInch: "6.1 inch (OLED)", dispResolution: "2532 x 1170 pixel", dispPpi: "460 ppi", rearCam: [.wide: "12 MP, f/1.6", .ultraWide: "12 MP, f/2.4"], frontCam: [.wide: "12 MP, f/2.2"], weight: "162 g", battery: (capacity: 2775, unit: .mAh), releaseDate: "2020/10/23", technicalSpecificationsUrl: "kb/SP830"),
        DeviceData(deviceName: "iPhone 12 mini", chip: Chip.a14Bionic.data, memoryCapacity: "4 GB",  dispInch: "5.4 inch (OLED)", dispResolution: "2340 x 1080 pixel", dispPpi: "476 ppi", rearCam: [.wide: "12 MP, f/1.6", .ultraWide: "12 MP, f/2.4"], frontCam: [.wide: "12 MP, f/2.2"], weight: "133 g", battery: (capacity: 2227, unit: .mAh), releaseDate: "2020/11/13", technicalSpecificationsUrl: "kb/SP829"),
        DeviceData(deviceName: "iPhone 8", chip: Chip.a11Bionic.data, memoryCapacity: "2 GB",  dispInch: "4.7 inch (IPS)", dispResolution: "1334 x 750 pixel", dispPpi: "326 ppi", rearCam: [.wide: "12 MP, f/1.8"], frontCam: [.wide: "7 MP, f/2.2"], weight: "148 g", battery: (capacity: 1821, unit: .mAh), releaseDate: "2017/09/22", technicalSpecificationsUrl: "kb/SP767"),
        DeviceData(deviceName: "iPhone 7", chip: Chip.a10Fusion.data, memoryCapacity: "2 GB (LPDDR4)",  dispInch: "4.7 inch (IPS)", dispResolution: "1334 x 750 pixel", dispPpi: "326 ppi", rearCam: [.wide: "12 MP, f/1.8"], frontCam: [.wide: "7 MP, f/2.2"], weight: "138 g", battery: (capacity: 1960, unit: .mAh), releaseDate: "2016/09/16", technicalSpecificationsUrl: "kb/SP743"),
        DeviceData(deviceName: "iPhone 5s", chip: Chip.a7.data, memoryCapacity: "1 GB (LPDDR3)",  dispInch: "4 inch (IPS)", dispResolution: "1136 x 640 pixel", dispPpi: "326 ppi", rearCam: [.wide: "8 MP, f/2.2"], frontCam: [.wide: "1.2 MP, f/2.4"], weight: "112 g", battery: (capacity: 1560, unit: .mAh), releaseDate: "2013/09/20", technicalSpecificationsUrl: "kb/sp685"),
    ]

    static let iPadArray = [
        DeviceData(deviceName: "iPad mini (6th generation)", chip: Chip.a15Bionic5GPU.data, memoryCapacity: "4 GB",  dispInch: "8.3 inch (IPS)", dispResolution: "2,266 x 1,488 pixel", dispPpi: "326 ppi", rearCam: [.wide: "12 MP, f/1.8"], frontCam: [.ultraWide: "12 MP, f/2.2"], weight: "293 g (Cellular: 297 g)", battery: (capacity: 19.3, unit: .wh), releaseDate: "2021/09/24", technicalSpecificationsUrl: "kb/SP850"),
    ]
}
