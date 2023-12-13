//
//  ChipData.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import Foundation

struct ChipData {
    var chipName: String //チップ名
    var manufacturingProcess: String //プロセスルール
    var cpuCoreNum: String //CPUコア数
    var gpuCoreNum: String //GPUコア数
    var neuralEngineCoreNum: String? //ニューラルエンジンコア数
}

enum Chip {
    //1. caseを追加
    case a15Bionic5GPU
    case a14Bionic
    case a11Bionic
    case a10Fusion
    case a7

    var data: ChipData {
        //2. caseに対応するChipDataを追加
        switch self {
        case .a15Bionic5GPU:
            return ChipData(chipName: "A15 Bionic (5-GPU)", manufacturingProcess: "5 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "5", neuralEngineCoreNum: "16")
        case .a14Bionic:
            return ChipData(chipName: "A14 Bionic", manufacturingProcess: "5 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "4", neuralEngineCoreNum: "16")
        case .a11Bionic:
            return ChipData(chipName: "A11 Bionic", manufacturingProcess: "10 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "3", neuralEngineCoreNum: "2")
        case .a10Fusion:
            return ChipData(chipName: "A10 Fusion", manufacturingProcess: "16 nm", cpuCoreNum: "4 (2P+2E)", gpuCoreNum: "-")
        case .a7:
            return ChipData(chipName: "A7", manufacturingProcess: "28 nm", cpuCoreNum: "2", gpuCoreNum: "-")
        }
    }
}
