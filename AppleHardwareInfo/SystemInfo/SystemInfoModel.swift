//
//  SystemInfoModel.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/02/22.
//

import SwiftUI

//システムのBoot TimeとUptimeを取得する
class SystemBoot {
    
    private func getBootDate() -> Date? {
        var tv = timeval()
        var tvSize = MemoryLayout<timeval>.size
        let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0);
        guard err == 0, tvSize == MemoryLayout<timeval>.size else {
            return nil
        }
        return Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
    }
    
    //システム起動時刻を返す
    func getBootTime() -> String {
        guard let systemBoot = getBootDate() else {
            return "Error: Failed to get system boot time."
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        let systemBootStr = formatter.string(from: systemBoot)
        return systemBootStr
    }
    
    //uptimeを返す
    func getUptime() -> String {
        guard let systemBoot = getBootDate() else {
            return "Error: Failed to get system boot time."
        }
        let now = Date()
        let uptime = now.timeIntervalSince(systemBoot)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        switch uptime {
        case (0..<60):
            formatter.allowedUnits = [.second]
        case (60..<60*60):
            formatter.allowedUnits = [.minute, .second]
        case (60*60..<24*60*60):
            formatter.allowedUnits = [.hour, .minute, .second]
        default:
            formatter.allowedUnits = [.day, .hour, .minute, .second]
        }
        formatter.zeroFormattingBehavior = .pad
        let uptimeStr = formatter.string(from: uptime)!
        print("⏱️: \(uptimeStr)") //->7d 1h 58m 44s
        return uptimeStr
    }
    
}

//端末の熱状態を監視
class ThermalMonitor: ObservableObject {
    
    @Published var status: ProcessInfo.ThermalState = .nominal
    
    func startMonitor() {
        print("🏃‍♂️⏸️: Thermal monitor started.")
        //熱状態の変化通知を受け取れるようにする
        NotificationCenter.default.addObserver(self, selector: #selector(thermalStatusChanged(notification:)), name: ProcessInfo.thermalStateDidChangeNotification, object: nil)
        //初回の更新
        status = ProcessInfo.processInfo.thermalState
    }
    
    func stopMonitor() {
        print("🧘‍♀️▶️: Thermal monitor stopped.")
        //通知を受け取らないように削除する
        NotificationCenter.default.removeObserver(self, name: ProcessInfo.thermalStateDidChangeNotification, object: nil)
    }
    
    @objc func thermalStatusChanged(notification: Notification) {
        print("😲‼️: Thermal monitor status changed.")
        DispatchQueue.main.async { //なんか紫のエラー出たんで追加したコード
            self.status = ProcessInfo.processInfo.thermalState
        }
    }
}

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
            case OS.iOS.rawValue:
                return Data.iPhoneList[index].batteryCapacity
            case OS.iPadOS.rawValue:
                return Data.iPadList[index].batteryCapacity
            default:
                break
            }
        }
        return "unknown mAh"
    }
}
