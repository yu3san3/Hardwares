//
//  AllDeviceListView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

struct AllDeviceListView: View {

    let device: Device

    let deviceNameArray: [String]
    let deviceArray: [DeviceData]

    @State private var searchText: String = ""

    //検索結果を格納する配列
    private var searchResults: [String] {
        if searchText.isEmpty {
            return deviceNameArray
        } else {
            return deviceNameArray.filter { $0.contains(searchText) }
        }
    }

    init(device: Device) {
        self.device = device

        switch device {
        case .iPhone:
            self.deviceNameArray = DeviceData.iPhoneNameArray
            self.deviceArray = DeviceData.iPhoneArray
        case .iPad:
            self.deviceNameArray = DeviceData.iPadNameArray
            self.deviceArray = DeviceData.iPadArray
        }
    }

    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { item in
                if let index = deviceNameArray.firstIndex(of: item) {
                    NavigationLink(
                        destination: DeviceDetailView(device: deviceArray[index])
                    ) {
                        Text(item)
                            .defaultStyle()
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
