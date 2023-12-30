//
//  AllDeviceListView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

struct AllDeviceListView: View {

    let device: Device
    let deviceDataArray: [DeviceData]

    init(device: Device) {
        self.device = device

        switch device {
        case .iPhone:
            self.deviceDataArray = DeviceData.iPhoneArray
        case .iPad:
            self.deviceDataArray = DeviceData.iPadArray
        }
    }

    @State private var searchText: String = ""

    //検索結果を格納する配列
    private var searchResults: [DeviceData] {
        if searchText.isEmpty {
            return deviceDataArray
        }
        return deviceDataArray.filter { $0.deviceName.contains(searchText) }
    }

    var body: some View {
        List {
            ForEach(searchResults) { deviceData in
                NavigationLink(
                    destination: DeviceDetailView(withData: deviceData)
                ) {
                    Text(deviceData.deviceName)
                        .defaultStyle()
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle(device.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AllDeviceListView(device: .iPhone)
}
