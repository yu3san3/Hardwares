//
//  DeviceDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI

struct DeviceDetailView: View {
    
    var device: DeviceData
    var chip: ChipData?
    
    @State private var shouldShowWebView: Bool = false
    @State private var shouldShowGlossaryView: Bool = false
    
    //チップ名のみの配列を作る
    let chipNameArray = Data.chipList.map({ (list) -> String in
        return list.chipName
    })

    let technicalSpecificationsUrl: URL?

    init(device: DeviceData) {
        self.device = device
        //chipListにおける現在のデバイスに搭載されているチップのindexを探してindexに代入
        if let index = chipNameArray.firstIndex(of: device.chip) {
            self.chip = Data.chipList[index]
        } else {
            self.chip = nil
        }
        //技術仕様のURLを完成させる
        self.technicalSpecificationsUrl = URL(
            string: "https://support.apple.com/" + device.technicalSpecificationsUrl
        )
    }
    
    var body: some View {
        List {
            if let chip = self.chip {
                Section {
                    SplitTextListItem(title: "SoC", element: chip.chipName)
                    SplitTextListItem(title: "プロセスルール", element: chip.manufacturingProcess)
                    SplitTextListItem(title: "CPUコア数", element: chip.cpuCoreNum)
                    SplitTextListItem(title: "GPUコア数", element: chip.gpuCoreNum)
                    if chip.neuralEngineCoreNum != nil {
                        SplitTextListItem(title: "Neural Engineコア数", element: chip.neuralEngineCoreNum!)
                    }
                } header: {
                    Text("チップ")
                } footer: {
                    Text("P: Performance  E: Efficiency")
                }
            } else {
                Text("Error: Chip data is not registered.")
            }
            Section {
                SplitTextListItem(title: "容量", element: device.memoryCapacity)
            } header: {
                Text("メモリ")
            }
            Section {
                SplitTextListItem(title: "サイズ", element: Localize.numbers(device.dispInch))
                SplitTextListItem(title: "解像度", element: Localize.numbers(device.dispResolution))
                SplitTextListItem(title: "画素密度", element: device.dispPpi)
            } header: {
                Text("ディスプレイ")
            }
            Section {
                if device.rearCam["wide"] != nil {
                    SplitTextListItem(title: "広角", element: device.rearCam["wide"]!)
                }
                if device.rearCam["ultraWide"] != nil {
                    SplitTextListItem(title: "超広角", element: device.rearCam["ultraWide"]!)
                }
                if device.rearCam["tele"] != nil {
                    SplitTextListItem(title: "望遠", element: device.rearCam["tele"]!)
                }
            } header: {
                Text("背面カメラ")
            }
            Section {
                if device.frontCam["wide"] != nil {
                    SplitTextListItem(title: "広角", element: device.frontCam["wide"]!)
                }
                if device.frontCam["ultraWide"] != nil {
                    SplitTextListItem(title: "超広角", element: device.frontCam["ultraWide"]!)
                }
            } header: {
                Text("前面カメラ")
            }
            Section {
                SplitTextListItem(title: "重量", element: device.weight)
                SplitTextListItem(title: "バッテリー容量", element: Localize.numbers(device.batteryCapacity))
                SplitTextListItem(title: "発売日", element: Localize.date(device.releaseDate))
            } header: {
                Text("その他")
            }
            Section {
                if let url = technicalSpecificationsUrl {
                    HStack {
                        Text("技術仕様 (support.apple.com)")
                            .foregroundColor(.blue)
                        Spacer() //セル全体をタップ領域にする
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
            } header: {
                Text("リンク")
            } footer: {
                Text("リーダーを表示すると読みやすくなります。")
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shouldShowGlossaryView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .sheet(isPresented: $shouldShowGlossaryView, content: {
                    GlossaryView() //用語集
                })
            }
        }
        .navigationTitle(device.deviceName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailView(device: Data.iPhoneList[0])
    }
}
