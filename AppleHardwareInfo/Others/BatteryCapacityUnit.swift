//
//  BatteryCapacityUnit.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/14.
//

import Foundation

enum BatteryCapacityUnit: String {
    case mAh = "mAh"
    case wh = "Wh"
}

extension BatteryCapacityUnit {
    public mutating func toggle() {
        switch self {
        case .mAh:
            self = .wh
        case .wh:
            self = .mAh
        }
    }
}
