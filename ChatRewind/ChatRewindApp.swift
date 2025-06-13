//
//  ChatRewindApp.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

@main
struct ChatRewindApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ChatRewindDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
