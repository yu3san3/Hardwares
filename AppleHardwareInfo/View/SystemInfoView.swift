//
//  SystemDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/25.
//

import SwiftUI

struct SystemInfoView: View {
    
    private let systemBoot = SystemBoot()
    
    @State private var systemUptimeText: String = ""
    @State private var uptimeTimer: Timer!
    
    @ObservedObject var thermalMonitor = ThermalMonitor()
    
    @ObservedObject var battery = Battery()
    
    var body: some View {
        List {
            Section {
                Group {
                    SplitTextListItem(
                        title: "システム",
                        element: UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                    )
                }
                Group {
                    let str: String = ProcessInfo.processInfo.operatingSystemVersionString
                    let array: [String] = str.components(separatedBy: " ")
                    let systemBuildNum: String = String(array.last!.dropLast(1))
                    SplitTextListItem(title: "システムビルド", element: systemBuildNum)
                }
            } header: {
                Text("現在のシステム")
            }
            Section {
                SplitTextListItem(title: "システム起動", element: systemBoot.getBootTime())
                Group {
                    HStack {
                        Text("稼働時間")
                            .defaultStyle()
                        Spacer()
                        Text(systemUptimeText.isEmpty ? systemBoot.getUptime() : systemUptimeText)
                            .font(.custom("monospacedDigitSystemFont", size: 16, relativeTo: .callout))
                    }
                    .onAppear {
                        print("🏃‍♂️⏸️: Uptime Timer set.")
                        //タイマーをセット
                        uptimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            systemUptimeText = systemBoot.getUptime()
                        }
                        //これがないと画面をスクロールしたときにタイマーが止まる
                        RunLoop.current.add(uptimeTimer, forMode: .common)
                    }
                    .onDisappear {
                        print("🧘‍♀️▶️: Uptime Timer invalidated.")
                        //タイマーを破棄
                        uptimeTimer.invalidate()
                    }
                }
            } header: {
                Text("システムの状態")
            }
            Group {
                Section {
                    HStack {
                        Text("熱状態")
                            .defaultStyle()
                        Spacer()
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
                } footer: {
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
                .onAppear() {
                    //熱状態の監視を開始する
                    self.thermalMonitor.startMonitor()
                }
                .onDisappear() {
                    //熱状態の監視を終了する
                    self.thermalMonitor.stopMonitor()
                }
            }
            Section {
                BatteryCorrectionListItem(type: .revisedCapacity)
                BatteryCorrectionListItem(type: .maximumCapacity)
                SplitTextListItem(
                    title: "実際の容量",
                    element: Localize.numbers(battery.actualCapacity)
                )
            } header: {
                Text("バッテリーの状態")
            }
        }
        .navigationTitle("システム情報")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SystemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SystemInfoView()
    }
}
