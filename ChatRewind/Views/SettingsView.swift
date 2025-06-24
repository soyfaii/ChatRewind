//
//  SettingsView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 24/6/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("showSevenTvEmotes") private var showSevenTvEmotes = false
    @AppStorage("maxDisplayedMessagesCount") private var maxDisplayedMessagesCount: Int = 200
    
    var body: some View {
        TabView {
            Tab("Player", systemImage: "play") {
                Form {
                    Toggle("Show 7TV Emotes", isOn: $showSevenTvEmotes)
                    Slider(
                        value: Binding(
                            get: { Double(maxDisplayedMessagesCount) },
                            set: { maxDisplayedMessagesCount = Int($0) }
                        ),
                        in: 50...500, // adjust range as needed
                        step: 25,
                    ) {
                        Text("Maximum displayed messages")
                    } minimumValueLabel: {
                        Text("50")
                    } maximumValueLabel: {
                        Text("500")
                    }
                    TextField(String(""), value: $maxDisplayedMessagesCount, format: .number)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                }
            }
        }
        .scenePadding()
        .frame(maxWidth: 500, minHeight: 100)
    }
}

#Preview {
    SettingsView()
}
