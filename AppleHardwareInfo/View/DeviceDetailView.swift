//
//  DeviceDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI

struct DeviceDetailView: View {

    var device: DeviceData

    @State private var batteryCapacityUnitDisplayMode: BatteryCapacityUnit
    @State private var timeDisplayMode: TimeDisplayMode = .monthDay

    @State private var shouldShowWebView: Bool = false
    @State private var shouldShowGlossaryView: Bool = false

    init(device: DeviceData) {
        self.device = device
        self._batteryCapacityUnitDisplayMode = State(initialValue: device.battery.unit)
    }

    var body: some View {
        List {
            chipSection
            memorySection
            displaySection
            rearCameraSection
            frontCameraSection
            othersSection
            linkSection
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shouldShowGlossaryView = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .sheet(isPresented: $shouldShowGlossaryView) {
                    GlossaryView() //用語集
                }
            }
        }
        .navigationTitle(device.deviceName)
        .navigationBarTitleDisplayMode(.inline)
    }

    var chipSection: some View {
        Section {
            SplitTextListItem(title: "SoC", element: device.chip.chipName)
            SplitTextListItem(title: "プロセスルール", element: device.chip.manufacturingProcess)
            SplitTextListItem(title: "CPUコア数", element: device.chip.cpuCoreNum)
            SplitTextListItem(title: "GPUコア数", element: device.chip.gpuCoreNum)
            if let neuralEngineCoreNum = device.chip.neuralEngineCoreNum {
                SplitTextListItem(title: "Neural Engineコア数", element: neuralEngineCoreNum)
            }
        } header: {
            Text("チップ")
        } footer: {
            Text("P: Performance  E: Efficiency")
        }
    }

    var memorySection: some View {
        Section {
            SplitTextListItem(title: "容量", element: device.memoryCapacity)
        } header: {
            Text("メモリ")
        }
    }

    var displaySection: some View {
        Section {
            SplitTextListItem(title: "サイズ", element: device.dispInch.localizedNumber)
            SplitTextListItem(title: "解像度", element: device.dispResolution.localizedNumber)
            SplitTextListItem(title: "画素密度", element: device.dispPpi)
        } header: {
            Text("ディスプレイ")
        }
    }

    var rearCameraSection: some View {
        Section {
            if let rearCamWide = device.rearCam[.wide] {
                SplitTextListItem(title: "広角", element: rearCamWide)
            }
            if let rearCamUltraWide = device.rearCam[.ultraWide] {
                SplitTextListItem(title: "超広角", element: rearCamUltraWide)
            }
            if let rearCamTele = device.rearCam[.tele] {
                SplitTextListItem(title: "望遠", element: rearCamTele)
            }
        } header: {
            Text("背面カメラ")
        }
    }

    var frontCameraSection: some View {
        Section {
            if let frontCamWide = device.frontCam[.wide] {
                SplitTextListItem(title: "広角", element: frontCamWide)
            }
            if let frontCamUltraWide = device.frontCam[.ultraWide] {
                SplitTextListItem(title: "超広角", element: frontCamUltraWide)
            }
        } header: {
            Text("前面カメラ")
        }
    }

    var othersSection: some View {
        Section {
            SplitTextListItem(title: "重量", element: device.weight)
            let capacityStr = getAppropriateBatteryCapacityStr()
            SplitTextListItem(title: "バッテリー容量", element: capacityStr.localizedNumber)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        batteryCapacityUnitDisplayMode.toggle()
                    }
            let element = getFormattedReleaseDateStr()
            SplitTextListItem(title: "発売日", element: element)
                .contentShape(Rectangle())
                .onTapGesture {
                    timeDisplayMode.toggle()
                }
        } header: {
            Text("その他")
        }
    }

    var linkSection: some View {
        Section {
            if let technicalSpecificationsUrl = URL(
                string: "https://support.apple.com/\(device.technicalSpecificationsUrl)"
            ) {
                HStack {
                    Text("技術仕様 (support.apple.com)")
                        .foregroundColor(.blue)
                    Spacer()
                }
                .contentShape(Rectangle()) //セル全体をタップ領域にする
                .onTapGesture {
                    shouldShowWebView.toggle()
                }
                .fullScreenCover(isPresented: $shouldShowWebView) {
                    SafariView(url: technicalSpecificationsUrl)
                        .edgesIgnoringSafeArea(.all)
                }
            } else {
                Text("Error: Invalid link to technical specification.")
            }
        } header: {
            Text("リンク")
        } footer: {
            Text("リーダーを表示すると読みやすくなります。")
        }
    }
}

private extension DeviceDetailView {
    func getAppropriateBatteryCapacityStr() -> String {
        let batteryVoltage = 3.82
        let capacity = device.battery.capacity
        let registeredUnit = device.battery.unit
        let displayMode = self.batteryCapacityUnitDisplayMode
        //登録されている単位(registeredUnit)と表示モード(displayMode)が同じなら、データ通りの値を返す。
        if registeredUnit == displayMode {
            return "\(capacity) \(registeredUnit.rawValue)"
        }
        //そうでなければ単位を変換
        switch registeredUnit {
        case .mAh: //mAh -> Wh
            let converted = (capacity * batteryVoltage)/1000
            let formatted = String(format: "%.2f", converted)
            return "約 \(formatted) \(displayMode.rawValue)"
        case .wh: //Wh -> mAh
            let converted = round( (capacity * 1000)/batteryVoltage )
            return "約 \(converted) \(displayMode.rawValue)"
        }
    }

    func getFormattedReleaseDateStr() -> String {
        switch self.timeDisplayMode {
        case .monthDay:
            return "\(device.releaseDate.localizedDate.monthDay)"
        case .daysElapsed:
            return "\(device.releaseDate.localizedDate.daysElapsed) 前"
        }
    }
}

#Preview {
    DeviceDetailView(device: DeviceData.iPhoneArray[0])
}
