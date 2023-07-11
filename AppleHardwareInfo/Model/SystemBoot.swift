//
//  SystemBoot.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import Foundation

//システムのBoot TimeとUptimeを取得する
class SystemBoot {
    //システム起動時刻を返す
    func getBootTime() -> String {
        guard let systemBoot = getBootDate() else {
            return "Error: Failed to get system boot time."
        }
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        let systemBootStr = formatter.string(from: systemBoot)
        return systemBootStr
    }

    //uptimeを返す
    func getUptime() -> String {
        guard let systemBoot = getBootDate() else {
            return "Error: Failed to get system boot time."
        }
        let now = Date()
        let uptime = now.timeIntervalSince(systemBoot)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        switch uptime {
        case (0..<60):
            formatter.allowedUnits = [.second]
        case (60..<60*60):
            formatter.allowedUnits = [.minute, .second]
        case (60*60..<24*60*60):
            formatter.allowedUnits = [.hour, .minute, .second]
        default:
            formatter.allowedUnits = [.day, .hour, .minute, .second]
        }
        formatter.zeroFormattingBehavior = .pad
        let uptimeStr = formatter.string(from: uptime)!
        print("⏱️: \(uptimeStr)") //->7d 1h 58m 44s
        return uptimeStr
    }

    private func getBootDate() -> Date? {
        var tv = timeval()
        var tvSize = MemoryLayout<timeval>.size
        let err = sysctlbyname("kern.boottime", &tv, &tvSize, nil, 0);
        guard err == 0, tvSize == MemoryLayout<timeval>.size else {
            return nil
        }
        return Date(timeIntervalSince1970: Double(tv.tv_sec) + Double(tv.tv_usec) / 1_000_000.0)
    }
}
