//
//  AllDeviceListView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

struct AllDeviceListView: View {

    var device: Device

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

struct AllDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        AllDeviceListView(device: .iPhone)
    }
}
