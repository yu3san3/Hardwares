//
//  DeviceDetailView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/11/16.
//

import SwiftUI
import BetterSafariView

enum Devices: String {
    case iPhone = "iPhone"
    case iPad = "iPad"
}

struct AllDeviceView: View {
    
    var device: Devices
    
    @State private var searchText: String = ""
    
    //デバイス名のみの配列を作る
    let iPhoneNameArray = Data.iPhoneList.map({ (list) -> String in
        return list.deviceName
    })
    let iPadNameArray = Data.iPadList.map({ (list) -> String in
        return list.deviceName
    })
    
    //検索結果を格納する配列
    private var searchResults: [String] {
        switch device {
        case .iPhone:
            if searchText.isEmpty {
                return iPhoneNameArray
            } else {
                return iPhoneNameArray.filter { $0.contains(searchText) }
            }
        case .iPad:
            if searchText.isEmpty {
                return iPadNameArray
            } else {
                return iPadNameArray.filter { $0.contains(searchText) }
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { item in
                switch device {
                case .iPhone:
                    if let index = iPhoneNameArray.firstIndex(of: item) {
                        NavigationLink(
                            destination: DeviceDetailView(device: Data.iPhoneList[index])
                        ) {
                            Text(item)
                                .defaultStyle()
                        }
                    }
                case .iPad:
                    if let index = iPadNameArray.firstIndex(of: item) {
                        NavigationLink(
                            destination: DeviceDetailView(device: Data.iPadList[index])
                        ) {
                            Text(item)
                                .defaultStyle()
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle(device.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DeviceDetailView: View {
    
    var device: DeviceData
    
    @State private var shouldShowWebView: Bool = false
    @State private var shoudShowGlossaryView: Bool = false
    
    //チップ名のみの配列を作る
    let chipNameArray = Data.chipList.map({ (list) -> String in
        return list.chipName
    })
    
    var body: some View {
        List {
            //chipListにおける現在のデバイスに搭載されているチップのindexを探してindexに代入
            if let index = chipNameArray.firstIndex(of: device.chip) {
                ChipDetailView(chip: Data.chipList[index])
            } else {
                Text("Error: Chip data is not registered.")
            }
            Section {
                DefaultListItem(item: "容量", element: device.memoryCapacity)
            } header: {
                Text("メモリ")
            }
            Section {
                DefaultListItem(item: "サイズ", element: Localize.numbers(device.dispInch))
                DefaultListItem(item: "解像度", element: Localize.numbers(device.dispResolution))
                DefaultListItem(item: "画素密度", element: device.dispPpi)
            } header: {
                Text("ディスプレイ")
            }
            Section {
                if device.rearCam["wide"] != nil {
                    DefaultListItem(item: "広角", element: device.rearCam["wide"]!)
                }
                if device.rearCam["ultraWide"] != nil {
                    DefaultListItem(item: "超広角", element: device.rearCam["ultraWide"]!)
                }
                if device.rearCam["tele"] != nil {
                    DefaultListItem(item: "望遠", element: device.rearCam["tele"]!)
                }
            } header: {
                Text("背面カメラ")
            }
            Section {
                if device.frontCam["wide"] != nil {
                    DefaultListItem(item: "広角", element: device.frontCam["wide"]!)
                }
                if device.frontCam["ultraWide"] != nil {
                    DefaultListItem(item: "超広角", element: device.frontCam["ultraWide"]!)
                }
            } header: {
                Text("前面カメラ")
            }
            Section {
                DefaultListItem(item: "重量", element: device.weight)
                DefaultListItem(item: "バッテリー容量", element: Localize.numbers(device.batteryCapacity))
                DefaultListItem(item: "発売日", element: Localize.date(device.releaseDate))
            } header: {
                Text("その他")
            }
            Section {
                if let technicalSpecificationsUrl = URL(
                    string: "https://support.apple.com/" + device.technicalSpecificationsUrl
                ) {
                    HStack {
                        Text("技術仕様 (support.apple.com)")
                            .foregroundColor(.blue)
                        Spacer() //セル全体をタップ領域にする
                    }
                    .contentShape(Rectangle()) //セル全体をタップ領域にする
                    .onTapGesture {
                        shouldShowWebView.toggle()
                    }.safariView(isPresented: $shouldShowWebView) {
                        SafariView(
                            url: technicalSpecificationsUrl,
                            configuration: SafariView.Configuration(
                                entersReaderIfAvailable: false,
                                barCollapsingEnabled: true
                            )
                        )
                        .preferredBarAccentColor(.clear)
                        .preferredControlAccentColor(.accentColor)
                        .dismissButtonStyle(.done)
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
                    shoudShowGlossaryView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .sheet(isPresented: $shoudShowGlossaryView, content: {
                    GlossaryView() //用語集
                })
            }
        }
        .navigationTitle(device.deviceName)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct ChipDetailView: View {
        
        var chip: ChipData
        
        var body: some View {
            Section {
                DefaultListItem(item: "SoC", element: chip.chipName)
                DefaultListItem(item: "プロセスルール", element: chip.manufacturingProcess)
                DefaultListItem(item: "CPUコア数", element: chip.cpuCoreNum)
                DefaultListItem(item: "GPUコア数", element: chip.gpuCoreNum)
                if chip.neuralEngineCoreNum != nil {
                    DefaultListItem(item: "Neural Engineコア数", element: chip.neuralEngineCoreNum!)
                }
            } header: {
                Text("チップ")
            } footer: {
                Text("P: Performance  E: Efficiency")
            }
        }
    }
}

public class Localize {
    
    //文字列を投げると、空白に挟まれた部分の数字がローカライズされる
    public static func numbers(_ str: String) -> String {
        
        var result: String = ""
        
        let array: [String] = str.components(separatedBy: " ") //文字列を空白で分けた配列に変換
        for i in 0 ..< array.count {
            if let float = Float(array[i]) {
                //Flotへ変換できた場合
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let commaAdded: String = formatter.string(from: NSNumber(value: float))! //コンマを追加
                result.append(commaAdded)
            } else {
                //Floatへ変換できなかった場合は要素をそのまま追加する(単位などがこれにあたる)
                result.append(array[i])
            }
            result.append(" ")
        }
        
        return String(result.dropLast()) //最後の余分な空白を取り除いて返す
    }
    
    //yyyy/MM/ddの形式をローカライズする
    public static func date(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        //ロケール設定(端末の暦設定に引きづられないようにする)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        //タイムゾーン設定(端末設定によらず、どこの地域の時間帯なのかを指定する)
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //いったんDate型に変換
        let releaseDate = formatter.date(from: dateStr)
        formatter.dateStyle = .long
        //ロケール設定を戻す
        formatter.locale = Locale(identifier: Locale.current.identifier)
        //Date型からString型に変換
        let releaseDateStr = formatter.string(from: releaseDate!)
        return releaseDateStr
    }
}

struct GlossaryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    GlossaryItem(item: "SoC", element: "SoCの解説")
                    GlossaryItem(item: "プロセスルール", element: "プロセスルールの解説")
                    GlossaryItem(item: "CPUコア数", element: "CPUコア数の解説")
                    GlossaryItem(item: "GPUコア数", element: "GPUコア数の解説")
                    GlossaryItem(item: "Neural Engineコア数", element: "Neural Engineの解説")
                }
                Section {
                    GlossaryItem(item: "メモリ容量", element: "メモリ容量の解説")
                }
                Section {
                    GlossaryItem(item: "画面サイズ", element: "画面サイズの解説")
                    GlossaryItem(item: "画面解像度", element: "画面解像度の解説")
                    GlossaryItem(item: "画素密度", element: "画素密度の解説")
                }
                Section {
                    GlossaryItem(item: "カメラ", element:"カメラの解説")
                }
                Section {
                    GlossaryItem(item: "重量", element: "重量の解説")
                    GlossaryItem(item: "バッテリー容量", element: "バッテリー容量の解説")
                    GlossaryItem(item: "発売日", element: "発売日の解説")
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .navigationBarTitle("用語解説", displayMode: .inline)
        }
    }
    
    struct GlossaryItem: View {
        
        let item: LocalizedStringKey
        let element: LocalizedStringKey
        
        @State private var isExpanded: Bool = false
        
        var body: some View {
            VStack {
                HStack {
                    Text("● \(item.toString())")
                        .fontWeight(.bold)
                        .defaultStyle()
                    Spacer()
                }
                Spacer()
                    .frame(height: 7)
                LongText(element.toString())
            }
        }
        
        struct LongText: View {

            /* 全てのテキストを表示するかを指定する */
            @State private var expanded: Bool = false

            /* テキストが切り捨てられた状態で表示されているかどうかを示す */
            @State private var truncated: Bool = false

            private var text: String

            var lineLimit = 3

            init(_ text: String) {
                self.text = text
            }

            var body: some View {
                VStack {
                    // 実際のテキストをレンダリングする(制限されるかもしれないし、されないかもしれない)
                    HStack {
                        Text(text)
                            .defaultStyle()
                            .lineLimit(expanded ? nil : lineLimit)
                        
                            .background(
                                // 限定されたテキストをレンダリングし、そのサイズを測定する
                                Text(text)
                                    .defaultStyle()
                                    .lineLimit(lineLimit)
                                    .background(GeometryReader { displayedGeometry in
                                        
                                        // 高さが制限されていないZStackを作成する。
                                        // 内側のTextに好きなだけ高さを与えるが、余分な幅は与えないようにする。
                                        ZStack {
                                            
                                            // テキストを無制限にレンダリングし、サイズを測定することができます。
                                            Text(self.text)
                                                .defaultStyle()
                                                .background(GeometryReader { fullGeometry in
                                                    
                                                    // そして、2つを比較する
                                                    Color.clear.onAppear {
                                                        self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                                    }
                                                })
                                        }
                                        .frame(height: .greatestFiniteMagnitude)
                                    })
                                    .hidden() // 背景を隠す
                            )
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 7)
                    HStack {
                        if truncated { toggleButton }
                        Spacer()
                    }
                }
            }

            var toggleButton: some View {
                Button(action: { self.expanded.toggle() }) {
                    Text(self.expanded ? "閉じる" : "さらに表示")
                        .font(.caption).bold()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AllDeviceView(device: .iPhone)
        DeviceDetailView(device: Data.iPhoneList[0])
        GlossaryView()
    }
}
