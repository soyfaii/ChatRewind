//
//  MessageView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    var emotesReferenceChannel: String
    var displayedText: Text {
        var parts: [Text] = []
        let emotes = SevenTVService.emotes[emotesReferenceChannel] ?? []
        print("Recieved emote names, from UI: \(emotes.map{ $0.name })")
        // Split text in words
        let words = message.message.components(separatedBy: .whitespaces)
        // Check if a word must be replaced by an emote
        words.forEach { word in
            if emotes.map({ $0.name }).contains(word) {
                // If it's on the list, adds the correspondent emote
                if let emote = emote(word) {
                    parts.append(Text(emote))
                } else {
                    parts.append(Text(word))
                }
            } else {
                // If it's not, we just add the word as is
                parts.append(Text(word))
            }
            parts.append(Text(String(" ")))
        }
        return parts.reduce(Text(String("")), +)
    }
    var onNameClick: () -> Void = {}
    var body: some View {
        Group {
            Text("**[\(message.username)](link):** ") + displayedText
        }
        .tint(message.userColor)
        .environment(\.openURL, OpenURLAction { url in
            onNameClick()
            return .handled
        })
    }
    
    func emote(_ name: String) -> Image? {
        return SevenTVService.getEmoteFromLoad(name, forChannel: emotesReferenceChannel)
    }
}

#Preview {
    VStack {
        MessageView(
            message: Message(time: 9, username: "SoyFaii", userColor: Color.blue, message: "FINALLY"), emotesReferenceChannel: "SoyFaii"
        )
        MessageView(
            message: Message(time: 9, username: "SoyFaii", userColor: Color.blue, message: "Sadge"), emotesReferenceChannel: "SoyFaii"
        )
        MessageView(
            message: Message(time: 9, username: "SoyFaii", userColor: Color.blue, message: "DonoWall"), emotesReferenceChannel: "SoyFaii"
        )
    }
    .task {
        await SevenTVService.loadEmotes(forChannel: "SoyFaii")
    }
}
