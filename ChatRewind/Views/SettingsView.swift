//
//  SettingsView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 24/6/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showSevenTvEmotes") private var showSevenTvEmotes = false
    var body: some View {
        TabView {
            Tab("Player", systemImage: "play") {
                Form {
                    Toggle("Show 7TV Emotes", isOn: $showSevenTvEmotes)
                }
            }
        }
        .scenePadding()
        .frame(maxWidth: 350, minHeight: 100)
    }
}

#Preview {
    SettingsView()
}
