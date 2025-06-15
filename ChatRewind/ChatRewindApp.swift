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
        .windowLevel(globals.keepOnTop ? .floating : .normal)
        .commands {
            CommandGroup(before: .sidebar) {
                Section {
                    Toggle(isOn: $globals.showPlayerControls) {
                        Label("Show Player Controls", systemImage: "play")
                    }
                }
            }
            CommandGroup(after: .windowSize) {
                Toggle(isOn: $globals.keepOnTop) {
                    Text("Keep on Top")
                }
            }
        }
    }
}

@Observable
class Globals {
    var showPlayerControls = true
    var keepOnTop = false
}
