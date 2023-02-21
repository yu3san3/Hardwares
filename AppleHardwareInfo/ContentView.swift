//
//  ContentView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2022/05/20.
//
//  2022/10/31 Alpha 1.0.0(1)
//       11/01 Alpha 1.0.1(2)
//       11/02 Alpha 1.1.0(3)
//       11/03 Alpha 1.2.0(4)
//       11/06 Alpha 1.3.0(5)
//       11/10 Alpha 1.4.0(6)
//       11/13 Alpha 1.5.0(7)
//       11/17 Alpha 1.6.0(8)
//       11/18 Alpha 1.7.0(9)
//       11/19 Alpha 1.7.1(10)
//       11/26 Alpha 1.8.0(11)
//       11/29 Alpha 1.8.1(12)
//

import SwiftUI
//import Combine
import BetterSafariView
//import Foundation

//バージョン情報
let globalAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let globalAppBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {
    
    @State private var isWebView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AllDeviceView(device: "iPhone")) {
                        HStack {
                            Image(systemName: "iphone")
                            Text("iPhone")
                                .defaultStyle()
                        }
                    }
                    NavigationLink(destination: AllDeviceView(device: "iPad")) {
                        HStack {
                            Image(systemName: "ipad")
                            Text("iPad")
                                .defaultStyle()
                        }
                    }
                }
                Section {
                    Group {
                        if let index = GetIndexInDeviceList.currentDevice() {
                            switch UIDevice.current.systemName {
                            case "iOS":
                                NavigationLink(destination: DeviceDetailView(device: iPhoneList[index])) {
                                    HStack {
                                        Image(systemName: "ipad.and.iphone")
                                        Text(iPhoneList[index].deviceName)
                                            .defaultStyle()
                                    }
                                }
                            case "iPadOS":
                                NavigationLink(destination: DeviceDetailView(device: iPadList[index])) {
                                    HStack {
                                        Image(systemName: "ipad.and.iphone")
                                        Text(iPadList[index].deviceName)
                                            .defaultStyle()
                                    }
                                }
                            default:
                                Text("Error: This app does not support the running OS.")
                            }
                        } else {
                            HStack {
                                Image(systemName: "ipad.and.iphone")
                                DefaultListItem(item: "端末名", element: UIDevice.current.name)
                            }
                        }
                    }
                    NavigationLink(destination: SystemDetailView()) {
                        HStack {
                            Image(systemName: "cpu")
                            let systemVersionStr: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                            DefaultListItem(item: "システム情報", element: systemVersionStr)
                        }
                    }
                } header: {
                    Text("この端末について")
                }
                Section {
                    Group {
                        if let url = URL(string: "https://www.apple.com/") {
                            let appleLinkText: LocalizedStringKey = "apple.com (デフォルトブラウザ)"
                            HStack {
                                Image(systemName: "safari")
                                    .foregroundColor(.blue)
                                Link(appleLinkText, destination: url)
                            }
                        }
                    }
                    Group {
                        if let speedtestUrl = URL(string: "https://fast.com") {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundColor(.blue)
                                Text("スピードテスト (fast.com)")
                                    .foregroundColor(.blue)
                                Spacer() //セル全体をタップ領域にする
                            }
                            .contentShape(Rectangle()) //セル全体をタップ領域にする
                            .onTapGesture {
                                isWebView.toggle()
                            }.safariView(isPresented: $isWebView) {
                                SafariView(
                                    url: speedtestUrl,
                                    configuration: SafariView.Configuration(
                                        entersReaderIfAvailable: false,
                                        barCollapsingEnabled: true
                                    )
                                )
                                .preferredBarAccentColor(.clear)
                                .preferredControlAccentColor(.accentColor)
                                .dismissButtonStyle(.done)
                            }
                        }
                    }
                } header: {
                    Text("リンク")
                }
                Section {
                    DefaultListItem(item: "バージョン", element: globalAppVersion)
                    DefaultListItem(item: "ビルド", element: globalAppBuildNum)
                } header: {
                    Text("このアプリについて")
                }
            }
            .navigationTitle("トップ")
            //iPadでの表示を調整
            .listStyle(.insetGrouped)
            SystemDetailView()
        }
    }
    
    //CPUとメモリの使用率
    //    // CPU使用率を0%~100%で取得
    //    private func getCPUUsage() -> Float {
    //        // カーネル処理の結果
    //        var result: Int32
    //        var threadList = UnsafeMutablePointer<UInt32>.allocate(capacity: 1)
    //        var threadCount = UInt32(MemoryLayout<mach_task_basic_info_data_t>.size / MemoryLayout<natural_t>.size)
    //        var threadInfo = thread_basic_info()
    //
    //        // スレッド情報を取得
    //        result = withUnsafeMutablePointer(to: &threadList) {
    //            $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
    //                task_threads(mach_task_self_, $0, &threadCount)
    //            }
    //        }
    //
    //        if result != KERN_SUCCESS { return 0 }
    //
    //        // 各スレッドからCPU使用率を算出し合計を全体のCPU使用率とする
    //        return (0 ..< Int(threadCount))
    //            // スレッドのCPU使用率を取得
    //            .compactMap { index -> Float? in
    //                var threadInfoCount = UInt32(THREAD_INFO_MAX)
    //                result = withUnsafeMutablePointer(to: &threadInfo) {
    //                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
    //                        thread_info(threadList[index], UInt32(THREAD_BASIC_INFO), $0, &threadInfoCount)
    //                    }
    //                }
    //                // スレッド情報が取れない = 該当スレッドのCPU使用率を0とみなす(基本nilが返ることはない)
    //                if result != KERN_SUCCESS { return nil }
    //                let isIdle = threadInfo.flags == TH_FLAGS_IDLE
    //                // CPU使用率がスケール調整済みのため`TH_USAGE_SCALE`で除算し戻す
    //                return !isIdle ? (Float(threadInfo.cpu_usage) / Float(TH_USAGE_SCALE)) * 100 : nil
    //            }
    //            // 合計算出
    //            .reduce(0, +)
    //    }
    //
    //    // 使用者が単位を把握できるようにするため
    //    typealias MegaByte = UInt64
    //    // 引数にenumで任意の単位を指定できるのが好ましい e.g. unit = .auto (デフォルト引数)
    //    func getMemoryUsed() -> MegaByte? {
    //        // タスク情報を取得
    //        var info = mach_task_basic_info()
    //        // `info`の値からその型に必要なメモリを取得
    //        var count = UInt32(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
    //        let result = withUnsafeMutablePointer(to: &info) {
    //            task_info(mach_task_self_,
    //                      task_flavor_t(MACH_TASK_BASIC_INFO),
    //                      // `task_info`の引数にするためにInt32のメモリ配置と解釈させる必要がある
    //                      $0.withMemoryRebound(to: Int32.self, capacity: 1) { pointer in
    //                        UnsafeMutablePointer<Int32>(pointer)
    //                      }, &count)
    //        }
    //        // MB表記に変換して返却
    //        return result == KERN_SUCCESS ? info.resident_size / 1024 / 1024 : nil
    //    }
}

//Listにおける項目のインデックスを取得
public class GetIndexInDeviceList {
    //現在のデバイス
    public static func currentDevice() -> Int? {
        switch UIDevice.current.systemName {
        case "iOS":
            for i in 0 ..< iPhoneList.count {
                if YMTGetDeviceName.getDeviceName() == iPhoneList[i].deviceName {
                    return i
                }
            }
        case "iPadOS":
            for i in 0 ..< iPadList.count {
                if YMTGetDeviceName.getDeviceName() == iPadList[i].deviceName {
                    return i
                }
            }
        default:
            break
        }
        return nil
    }
}

struct DefaultListItem: View {
    
    let item: LocalizedStringKey
    let element: String
    
    var body: some View {
        HStack {
            Text(item)
                .defaultStyle()
            Spacer()
            Text(element)
                .defaultStyle()
        }
    }
}

extension Text {
    func defaultStyle() -> some View {
        self.font(.system(.callout, design: .rounded))
    }
}

extension LocalizedStringKey {
    /**
     Return localized value of thisLocalizedStringKey
     */
    public func toString() -> String {
        //use reflection
        let mirror = Mirror(reflecting: self)
        
        //try to find 'key' attribute value
        let attributeLabelAndValue = mirror.children.first { (arg0) -> Bool in
            let (label, _) = arg0
            if(label == "key"){
                return true;
            }
            return false;
        }
        
        if(attributeLabelAndValue != nil) {
            //ask for localization of found key via NSLocalizedString
            return String.localizedStringWithFormat(NSLocalizedString(attributeLabelAndValue!.value as! String, comment: ""));
        }
        else {
            return "Swift LocalizedStringKey signature must have changed."
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        DeviceDetailView(device: iPhoneList[0])
    }
}
