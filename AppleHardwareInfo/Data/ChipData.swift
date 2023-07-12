//
//  ChipData.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import Foundation

struct ChipData: Identifiable {
    var id = UUID()
    var chipName: String //チップ名
    var manufacturingProcess: String //プロセスルール
    var cpuCoreNum: String //CPUコア数
    var gpuCoreNum: String //GPUコア数
    var neuralEngineCoreNum: String? //ニューラルエンジンコア数
}

extension ChipData {
    static let chipArray = [
        //ChipData(chipName: "", manufacturingProcess: " nm", cpuCoreNum: " (P+E)", gpuCoreNum: "", neuralEngineCoreNum: ""),
        ChipData(chipName: "A15 Bionic (5-GPU)", manufacturingProcess: "5 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "5", neuralEngineCoreNum: "16"),
        ChipData(chipName: "A14 Bionic", manufacturingProcess: "5 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "4", neuralEngineCoreNum: "16"),
        ChipData(chipName: "A11 Bionic", manufacturingProcess: "10 nm", cpuCoreNum: "6 (2P+4E)", gpuCoreNum: "3", neuralEngineCoreNum: "2"),
        ChipData(chipName: "A10 Fusion", manufacturingProcess: "16 nm", cpuCoreNum: "4 (2P+2E)", gpuCoreNum: "-"),
        ChipData(chipName: "A7", manufacturingProcess: "28 nm", cpuCoreNum: "2", gpuCoreNum: "-"),
    ]
}