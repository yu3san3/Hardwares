//
//  ThermalMonitor.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import Foundation

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
