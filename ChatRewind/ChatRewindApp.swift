//
//  ChatRewindApp.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

@main
struct ChatRewindApp: App {
    @State var globals = Globals()
    
    var body: some Scene {
        DocumentGroup(newDocument: ChatLog()) { file in
            NavigationStack {
                ContentView(chatLog: file.document)
                    .environment(globals)
            }
        }
        .commands {
            CommandGroup(before: .sidebar) {
                Section {
                    Toggle(isOn: $globals.showPlayerControls) {
                        Label("Show Player Controls", systemImage: "play")
                    }
                }
            }
        }
    }
}

@Observable
class Globals {
    var showPlayerControls = true
}
