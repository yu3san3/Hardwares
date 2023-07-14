//
//  GlossaryView.swift
//  AppleHardwareInfo
//
//  Created by 丹羽雄一朗 on 2023/07/12.
//

import SwiftUI

struct GlossaryView: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section {
                    GlossaryItem(item: "SoC", element: "SoCの解説")
                    GlossaryItem(item: "プロセスルール", element: "プロセスルールの解説")
                    GlossaryItem(item: "CPUコア数", element: "CPUコア数の解説")
                    GlossaryItem(item: "GPUコア数", element: "GPUコア数の解説")
                    GlossaryItem(item: "Neural Engineコア数", element: "Neural Engineの解説")
                }
                Section {
                    GlossaryItem(item: "メモリ容量", element: "メモリ容量の解説")
                }
                Section {
                    GlossaryItem(item: "画面サイズ", element: "画面サイズの解説")
                    GlossaryItem(item: "画面解像度", element: "画面解像度の解説")
                    GlossaryItem(item: "画素密度", element: "画素密度の解説")
                }
                Section {
                    GlossaryItem(item: "カメラ", element:"カメラの解説")
                }
                Section {
                    GlossaryItem(item: "重量", element: "重量の解説")
                    GlossaryItem(item: "バッテリー容量", element: "バッテリー容量の解説")
                    GlossaryItem(item: "発売日", element: "発売日の解説")
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationBarTitle("用語解説", displayMode: .inline)
        }
    }
}


struct GlossaryView_Previews: PreviewProvider {
    static var previews: some View {
        GlossaryView()
    }
}
