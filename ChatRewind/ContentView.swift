//
//  ContentView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: ChatRewindDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(ChatRewindDocument()))
}
