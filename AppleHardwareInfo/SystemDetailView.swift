//
//  SystemDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/25.
//

import SwiftUI

struct SystemDetailView: View {
    
    private var systemBoot = SystemBoot()
    
    @State private var systemUptimeText: String = ""
    @State private var uptimeTimer: Timer!
    
    @ObservedObject var thermalMonitor = ThermalMonitor()
    
    @ObservedObject var storage = Storage()
    
    var body: some View {
        List {
            Section {
                Group {
                    let systemVersion: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                    DefaultListItem(item: "システム", element: systemVersion)
                }
                Group {
                    let str: String = ProcessInfo.processInfo.operatingSystemVersionString
                    let array: Array = str.components(separatedBy: " ")
                    let systemBuildNum: Array = array[3].dropLast(1) //カッコを取る
                    DefaultListItem(item: "システムビルド", element: String(systemBuildNum))
                }
            } header: {
                Text("現在のシステム")
            }
            Section {
                DefaultListItem(item: "システム起動", element: systemBoot.getSystemBoot())
                Group {
                    HStack {
                        Text("稼働時間")
                            .defaultStyle()
                        Spacer()
                        Text(systemUptimeText.isEmpty ? systemBoot.getSystemUptime() : systemUptimeText)
                            .font(.custom("monospacedDigitSystemFont", size: 16, relativeTo: .callout))
                    }
                    .onAppear {
                        print("🏃‍♂️⏸️: Uptime Timer set.")
                        //タイマーをセット
                        uptimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            systemUptimeText = systemBoot.getSystemUptime()
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
//                CPUとGPUの使用率を表示
//                HStack {
//                    Text("CPU使用率")
//                    Spacer()
//                    let str = String(getCPUUsage())
//                    Text(str + "%")
//                }
//                HStack {
//                    Text("メモリ使用量")
//                    Spacer()
//                    let str = String(getMemoryUsed() ?? 0)
//                    Text(str + "MB")
//                }
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
                BatteryListItem(types: .revisedCapacity, item: "容量", placeholder: "0 mAh")
                BatteryListItem(types: .maximumCapacity, item: "最大容量", placeholder: "100 %")
                DefaultListItem(item: "実際の容量", element: Localize.numbers(calculateActualCapacity()))
            } header: {
                Text("バッテリーの状態")
            }
        }
        .navigationTitle("システム情報")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    //実際のバッテリー容量を計算
    private func calculateActualCapacity() -> String {
        //文字列の冒頭の数字のみを取得
        func getNumbers(_ str: String) -> Float? {
            let array: [String] = str.components(separatedBy: " ") //文字列を空白で分けた配列に変換
            return Float(array[0])
        }
        
        guard let revisedCapacity: Float = getNumbers(storage.revisedBatteryCapacity) else { //2000 mAh → 2000
            return "-"
        }
        guard let maximumCapacity: Float = getNumbers(storage.maximumBatteryCapacity) else { //98 % → 98
            return "Error: Invalid Value."
        }
        let actualCapacity: Float = round(revisedCapacity * (maximumCapacity / 100)) //2000 * 0.98
        let array: [String] = storage.revisedBatteryCapacity.components(separatedBy: " ") //文字列を空白で分けた配列に変換
        return String(actualCapacity) + " " + array[1] //array[1]が存在しないとクラッシュする
    }
}

struct BatteryListItem: View {
    
    let types: ObjectTypes
    
    enum ObjectTypes {
        case revisedCapacity
        case maximumCapacity
    }
    
    let item: LocalizedStringKey
    let placeholder: LocalizedStringKey
    
    private var element: String {
        switch types {
        case .revisedCapacity:
            return storage.revisedBatteryCapacity
        case .maximumCapacity:
            return storage.maximumBatteryCapacity
        }
    }
    
    @State private var isTapped: Bool = false
    @State private var textFieldContent: String = ""
    
    @ObservedObject var storage = Storage()
    
    var body: some View {
        let array: [String] = element.components(separatedBy: " ")
        HStack {
            Text(item)
                .defaultStyle()
            Spacer()
            Text(Localize.numbers(element))
                .defaultStyle()
            Image(systemName: "chevron.forward") //Disclosure Indicator(>)
                .font(Font.system(.caption).weight(.bold))
                .foregroundColor(Color(UIColor.tertiaryLabel))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            textFieldContent = String(array[0])
            self.isTapped.toggle()
        }
        .alert(
            "\(item.toString())の補正",
            isPresented: $isTapped,
            actions: {
                TextField(placeholder, text: $textFieldContent)
                    .keyboardType(.numberPad)
                //テキストを全選択
                    .onReceive(
                        NotificationCenter.default.publisher(
                            for: UITextField.textDidBeginEditingNotification
                        )
                    ) { obj in
                        if let textField = obj.object as? UITextField {
                            textField.selectedTextRange = textField.textRange(
                                from: textField.beginningOfDocument,
                                to: textField.endOfDocument
                            )
                        }
                    }
                Button("OK") {
                    switch types {
                    case .revisedCapacity:
                        storage.revisedBatteryCapacity = textFieldContent + " " + String(array[1]) //array[1]が存在しないとクラッシュする
                    case .maximumCapacity:
                        storage.maximumBatteryCapacity = textFieldContent + " " + String(array[1]) //array[1]が存在しないとクラッシュする
                    }
                }
                Button("キャンセル", role: .cancel) {}
            }, message: {
                Text("現在の値: \(Localize.numbers(element))")
            }
        )
    }
}

//system bootとuptimeを取得する
class SystemBoot {
    
    private func getSystemBootDate() -> Date? {
        var tv = timeval()
        var tvSize = MemoryLayout<timeval>.size
        let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0);
        guard err == 0, tvSize == MemoryLayout<timeval>.size else {
            return nil
        }
        return Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
    }
    
    //システム起動時刻を返す
    func getSystemBoot() -> String {
        guard let systemBoot = getSystemBootDate() else {
            return "Error: Failed to get system boot time."
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        let systemBootStr = formatter.string(from: systemBoot)
        return systemBootStr
    }
    
    //uptimeを返す
    func getSystemUptime() -> String {
        guard let systemBoot = getSystemBootDate() else {
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
    
    @objc func thermalStatusChanged(notification: Notification){
        print("😲‼️: Thermal monitor status changed.")
        DispatchQueue.main.async { //なんか紫のエラー出たんで追加したコード
            self.status = ProcessInfo.processInfo.thermalState
        }
    }
}

class Storage: ObservableObject {
    
    @AppStorage("revicedBatteryCapacityKey") var revisedBatteryCapacity: String = "default"
    @AppStorage("maximumBatteryCapacityKey") var maximumBatteryCapacity: String = "100 %"
    
    init() {
        if revisedBatteryCapacity == "default" {
            revisedBatteryCapacity = revisedBatteryCapacityDefault
        }
    }
    
    private var revisedBatteryCapacityDefault: String {
        if let index = GetIndexInDeviceList.currentDevice() {
            switch UIDevice.current.systemName {
            case "iOS":
                return iPhoneList[index].batteryCapacity
            case "iPadOS":
                return iPadList[index].batteryCapacity
            default:
                break
            }
        }
        return "unknown mAh"
    }
}

struct SystemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SystemDetailView()
    }
}
