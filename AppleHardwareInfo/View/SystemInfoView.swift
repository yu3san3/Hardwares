//
//  SystemDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/25.
//

import SwiftUI

struct SystemInfoView: View {
    
    private let systemBoot = SystemBoot()
    
    @StateObject var thermalMonitor = ThermalMonitor()
    @ObservedObject var battery = Battery()

    @State private var systemUptimeText: String = ""
    @State private var uptimeTimer: Timer!
    
    var body: some View {
        List {
            Section {
                systemListItem
                systemBuildListItem
            } header: {
                Text("現在のシステム")
            }
            Section {
                SplitTextListItem(title: "システム起動", element: systemBoot.getBootTime())
                uptimeListItem
                    .onAppear {
                        setUptimeTimer()
                    }
                    .onDisappear {
                        invalidateUptimeTimer()
                    }
            } header: {
                Text("システムの状態")
            }
            Section {
                thermalStateListItem
                    .onAppear() {
                        //熱状態の監視を開始する
                        thermalMonitor.startMonitor()
                    }
                    .onDisappear() {
                        //熱状態の監視を終了する
                        thermalMonitor.stopMonitor()
                    }
            } footer: {
                makeThermalStateFooter()
            }
            Section {
                BatteryCorrectionListItem(type: .revisedCapacity)
                BatteryCorrectionListItem(type: .maximumCapacity)
                makeActualCapacityListItem()
            } header: {
                Text("バッテリーの状態")
            }
        }
        .navigationTitle("システム情報")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension SystemInfoView {
    var systemListItem: some View {
        let systemName = UIDevice.current.systemName
        let systemVersion = getSystemVersion()
        let systemNameAndVersion = "\(systemName) \(systemVersion)"
        return SplitTextListItem(
            title: "システム",
            element: systemNameAndVersion
        )
    }

    func getSystemVersion() -> String {
        let systemVersion: String = ProcessInfo.processInfo.operatingSystemVersionString
        let array: [String] = systemVersion.components(separatedBy: " ")
        if array.count == 4 { //セキュリティパッチがない場合
            return array[1]
        } else if array.count == 5 { //セキュリティパッチがある場合
            return "\(array[1]) \(array[2])"
        } else {
            return "Error: Failed to get system version (array.count: \(array.count)"
        }
    }

    var systemBuildListItem: some View {
        //Version 16.5.1 (c) (Build 20F770750d)
        let systemVersionStr: String = ProcessInfo.processInfo.operatingSystemVersionString
        let array: [String] = systemVersionStr.components(separatedBy: " ")
        let systemBuildNum: String = String(array.last!.dropLast(1))
        return SplitTextListItem(title: "システムビルド", element: systemBuildNum)
    }

    var uptimeListItem: some View {
        HStack {
            Text("稼働時間")
                .defaultStyle()
            Spacer()
            Text(systemUptimeText.isEmpty ? systemBoot.getUptime() : systemUptimeText)
                .font(.custom("monospacedDigitSystemFont", size: 16, relativeTo: .callout))
        }
    }

    func setUptimeTimer() {
        print("🏃‍♂️⏸️: Uptime Timer set.")
        //タイマーをセット
        uptimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            systemUptimeText = systemBoot.getUptime()
        }
        //これがないと画面をスクロールしたときにタイマーが止まる
        RunLoop.current.add(uptimeTimer, forMode: .common)
    }

    func invalidateUptimeTimer() {
        print("🧘‍♀️▶️: Uptime Timer invalidated.")
        //タイマーを破棄
        uptimeTimer.invalidate()
    }

    var thermalStateListItem: some View {
        HStack {
            Text("熱状態")
                .defaultStyle()
            Spacer()
            makeThermalStateElement()
        }
    }

    @ViewBuilder
    func makeThermalStateElement() -> some View {
        switch thermalMonitor.status {
        case .nominal:
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.green)
                Text("正常")
                    .defaultStyle()
            }
        case .fair:
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.yellow)
                Text("わずかに上昇")
                    .defaultStyle()
            }
        case .serious:
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                Text("高い")
                    .defaultStyle()
            }
        case .critical:
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.purple)
                Text("深刻")
                    .defaultStyle()
            }
        default:
            Text("Error: Unknown value of thermal state.")
        }
    }

    @ViewBuilder
    func makeThermalStateFooter() -> some View {
        switch thermalMonitor.status {
        case .nominal:
            Text("正常フッター")
        case .fair:
            Text("わずかに上昇フッター")
        case .serious:
            Text("高いフッター")
        case .critical:
            Text("深刻フッター")
        default:
            Text("Error: Unknown value of thermal state.")
        }
    }

    @ViewBuilder
    func makeActualCapacityListItem() -> some View {
        if let actualCapacity = battery.calculateActualCapacity() {
            let initialUnit = battery.getInitialCapacityUnit()
            switch initialUnit {
            case .mAh:
                SplitTextListItem(
                    title: "実際の容量",
                    element: "\(round(actualCapacity)) \(battery.revisedCapacityUnit)".localizedNumber
                )
            case .Wh:
                SplitTextListItem(
                    title: "実際の容量",
                    element: "\( String(format: "%.2f", actualCapacity) ) \(battery.revisedCapacityUnit)".localizedNumber
                )
            default:
                Text("Error: Initial capacity unit is nil")
            }
        } else {
            SplitTextListItem(
                title: "実際の容量",
                element: "-"
            )
        }
    }
}

struct SystemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SystemInfoView()
    }
}
