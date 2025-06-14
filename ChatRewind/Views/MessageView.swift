//
//  MessageView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

struct MessageView: View {
    var message: Message
    var onNameClick: () -> Void = {}
    var body: some View {
        Text("**[\(message.username)](link):** \(message.message)")
            .tint(message.userColor)
            .environment(\.openURL, OpenURLAction { url in
                onNameClick()
                return .handled
            })
    }
}

#Preview {
    MessageView(
        message: Message(time: 9, username: "SoyFaii", userColor: Color.blue, message: "FINALLY")
    )
}
