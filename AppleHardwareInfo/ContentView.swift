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
//  2023/02/22 Alpha 1.8.2(13)
//       05/18 Alpha 1.8.3(14)
//

import SwiftUI
import BetterSafariView

//バージョン情報
let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let appBuildNum = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

struct ContentView: View {
    
    @State private var shouldShowWebView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: AllDeviceView(device: .iPhone)) {
                        HStack {
                            Image(systemName: "iphone")
                            Text("iPhone")
                                .defaultStyle()
                        }
                    }
                    NavigationLink(destination: AllDeviceView(device: .iPad)) {
                        HStack {
                            Image(systemName: "ipad")
                            Text("iPad")
                                .defaultStyle()
                        }
                    }
                }
                Section {
                    //Device Name
                    Group {
                        if let index = Data.currentDeviceIndex {
                            switch UIDevice.current.systemName {
                            case OS.iOS.rawValue:
                                NavigationLink(
                                    destination: DeviceDetailView(device: Data.iPhoneList[index])
                                ) {
                                    HStack {
                                        Image(systemName: "ipad.and.iphone")
                                        Text(Data.iPhoneList[index].deviceName)
                                            .defaultStyle()
                                    }
                                }
                            case OS.iPadOS.rawValue:
                                NavigationLink(
                                    destination: DeviceDetailView(device: Data.iPadList[index])
                                ) {
                                    HStack {
                                        Image(systemName: "ipad.and.iphone")
                                        Text(Data.iPadList[index].deviceName)
                                            .defaultStyle()
                                    }
                                }
                            default:
                                Text("Error: This app does not support the running OS.")
                            }
                        } else {
                            HStack {
                                Image(systemName: "ipad.and.iphone")
                                SplitTextListItem(title: "端末名", element: UIDevice.current.name)
                            }
                        }
                    }
                    //System Info
                    NavigationLink(destination: SystemInfoView()) {
                        HStack {
                            Image(systemName: "cpu")
                            SplitTextListItem(
                                title: "システム情報",
                                element: UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                            )
                        }
                    }
                } header: {
                    Text("この端末について")
                }
                Section {
                    //apple.comへのリンク
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
                    //スピードテストへのリンク
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
                                shouldShowWebView = true
                            }
                            .safariView(isPresented: $shouldShowWebView) {
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
                    SplitTextListItem(title: "バージョン", element: appVersion)
                    SplitTextListItem(title: "ビルド", element: appBuildNum)
                } header: {
                    Text("このアプリについて")
                }
            }
            .navigationTitle("トップ")
            //iPadでの表示を調整
            .listStyle(.insetGrouped)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        DeviceDetailView(device: Data.iPhoneList[0])
    }
}
