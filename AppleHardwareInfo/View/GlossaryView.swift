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
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .navigationBarTitle("用語解説", displayMode: .inline)
        }
    }

    struct GlossaryItem: View {

        let item: LocalizedStringKey
        let element: LocalizedStringKey

        @State private var isExpanded: Bool = false

        var body: some View {
            VStack {
                HStack {
                    Text("● \(item.toString())")
                        .fontWeight(.bold)
                        .defaultStyle()
                    Spacer()
                }
                Spacer()
                    .frame(height: 7)
                LongText(element.toString())
            }
        }

        struct LongText: View {

            /* 全てのテキストを表示するかを指定する */
            @State private var expanded: Bool = false

            /* テキストが切り捨てられた状態で表示されているかどうかを示す */
            @State private var truncated: Bool = false

            private var text: String

            var lineLimit = 3

            init(_ text: String) {
                self.text = text
            }

            var body: some View {
                VStack {
                    // 実際のテキストをレンダリングする(制限されるかもしれないし、されないかもしれない)
                    HStack {
                        Text(text)
                            .defaultStyle()
                            .lineLimit(expanded ? nil : lineLimit)

                            .background(
                                // 限定されたテキストをレンダリングし、そのサイズを測定する
                                Text(text)
                                    .defaultStyle()
                                    .lineLimit(lineLimit)
                                    .background(GeometryReader { displayedGeometry in

                                        // 高さが制限されていないZStackを作成する。
                                        // 内側のTextに好きなだけ高さを与えるが、余分な幅は与えないようにする。
                                        ZStack {

                                            // テキストを無制限にレンダリングし、サイズを測定することができます。
                                            Text(self.text)
                                                .defaultStyle()
                                                .background(GeometryReader { fullGeometry in

                                                    // そして、2つを比較する
                                                    Color.clear.onAppear {
                                                        self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                                                    }
                                                })
                                        }
                                        .frame(height: .greatestFiniteMagnitude)
                                    })
                                    .hidden() // 背景を隠す
                            )
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 7)
                    HStack {
                        if truncated { toggleButton }
                        Spacer()
                    }
                }
            }

            var toggleButton: some View {
                Button(action: { self.expanded.toggle() }) {
                    Text(self.expanded ? "閉じる" : "さらに表示")
                        .font(.caption).bold()
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


struct GlossaryView_Previews: PreviewProvider {
    static var previews: some View {
        GlossaryView()
    }
}
