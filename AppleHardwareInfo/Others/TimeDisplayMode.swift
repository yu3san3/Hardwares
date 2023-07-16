//
//  TimeDisplayMode.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/16.
//

import Foundation

enum TimeDisplayMode {
    case monthDay
    case daysElapsed
}

extension TimeDisplayMode {
    public mutating func toggle() {
        switch self {
        case .monthDay:
            self = .daysElapsed
        case .daysElapsed:
            self = .monthDay
        }
    }
}
