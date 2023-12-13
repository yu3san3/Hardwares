//
//  DeviceDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI

struct DeviceDetailView: View {
    
    var device: DeviceData

    let technicalSpecificationsUrl: URL?
    @State private var batteryCapacityUnitDisplayMode: BatteryCapacityUnit

    let batteryVoltage = 3.82
    @State private var timeDisplayMode: TimeDisplayMode = .monthDay
    @State private var shouldShowWebView: Bool = false
    @State private var shouldShowGlossaryView: Bool = false

    init(device: DeviceData) {
        self.device = device
        //技術仕様のURLを完成させる
        self.technicalSpecificationsUrl = URL(
            string: "https://support.apple.com/\(device.technicalSpecificationsUrl)"
        )
        self._batteryCapacityUnitDisplayMode = State(initialValue: device.battery.unit)
    }
    
    var body: some View {
        List {
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
            Section {
                SplitTextListItem(title: "容量", element: device.memoryCapacity)
            } header: {
                Text("メモリ")
            }
            Section {
                SplitTextListItem(title: "サイズ", element: device.dispInch.localizedNumber)
                SplitTextListItem(title: "解像度", element: device.dispResolution.localizedNumber)
                SplitTextListItem(title: "画素密度", element: device.dispPpi)
            } header: {
                Text("ディスプレイ")
            }
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
            Section {
                SplitTextListItem(title: "重量", element: device.weight)
                makeBatteryCapacityListItem()
                makeReleaseDateListItem()
            } header: {
                Text("その他")
            }
            Section {
                makeLinkToTechnicalSpecification()
            } header: {
                Text("リンク")
            } footer: {
                Text("リーダーを表示すると読みやすくなります。")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                glossaryButton
                    .sheet(isPresented: $shouldShowGlossaryView) {
                        GlossaryView() //用語集
                    }
            }
        }
        .navigationTitle(device.deviceName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension DeviceDetailView {
    var glossaryButton: some View {
        Button(action: {
            shouldShowGlossaryView = true
        }) {
            Image(systemName: "info.circle")
        }
    }

    @ViewBuilder
    func makeBatteryCapacityListItem() -> some View {
        let capacity = device.battery.capacity
        let unit = device.battery.unit
        let element = getConvertedElement(capacity: capacity,
                                          unit: unit,
                                          displayMode: batteryCapacityUnitDisplayMode)
        SplitTextListItem(title: "バッテリー容量", element: element.localizedNumber)
            .contentShape(Rectangle())
            .onTapGesture {
                batteryCapacityUnitDisplayMode.toggle()
            }
    }

    func getConvertedElement(capacity: Double, unit: BatteryCapacityUnit, displayMode: BatteryCapacityUnit) -> String {
        if unit == displayMode {
            return "\(capacity) \(displayMode.rawValue)"
        }
        switch unit {
        case .mAh:
            let calculated = (capacity * batteryVoltage)/1000 //mAh -> Wh
            let formatted = String(format: "%.2f", calculated)
            return "約 \(formatted) \(displayMode.rawValue)"
        case .wh:
            let calculated = round( (capacity * 1000)/batteryVoltage ) //Wh -> mAh
            return "約 \(calculated) \(displayMode.rawValue)"
        }
    }

    @ViewBuilder
    func makeReleaseDateListItem() -> some View {
        let element = getReleaseDateElement()
        SplitTextListItem(title: "発売日", element: element)
            .contentShape(Rectangle())
            .onTapGesture {
                timeDisplayMode.toggle()
            }
    }

    func getReleaseDateElement() -> String {
        switch timeDisplayMode {
        case .monthDay:
            return "\(device.releaseDate.localizedDate.monthDay)"
        case .daysElapsed:
            return "\(device.releaseDate.localizedDate.daysElapsed) 前"
        }
    }

    @ViewBuilder
    func makeLinkToTechnicalSpecification() -> some View {
        if let url = technicalSpecificationsUrl {
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
                SafariView(url: url)
                    .edgesIgnoringSafeArea(.all)
            }
        } else {
            Text("Error: Invalid link to technical specification.")
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(device: DeviceData.iPhoneArray[0])
    }
}
