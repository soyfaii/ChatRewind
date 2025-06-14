//
//  ContentView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

struct ContentView: View {	
    @Environment(Globals.self) private var globals
    
    var chatLog: ChatLog
    
    @State private var displayedMessages: [Message] = []
    
    @State private var currentPosition: TimeInterval = TimeInterval(0)
    
    @State private var isPlaying: Bool = false
    @State private var timer: Timer? = nil
    
    var streamLength: TimeInterval {
        TimeInterval(chatLog.messages.last?.time ?? 0)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    List {
                        if let streamName = chatLog.streamName {
                            StreamInfoView(streamName: streamName, channelName: chatLog.channelName)
                                .opacity(0)
                                .background(.background)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                        }
                        ForEach(globals.showPlayerControls ? displayedMessages : chatLog.messages, id: \.self) { message in
                            MessageView(message: message)
                                .id(message)
                        }
                    }
                    .onAppear {
                        if let lastMessage = (globals.showPlayerControls ? displayedMessages : chatLog.messages).last {
                            proxy.scrollTo(lastMessage, anchor: .bottom)
                        }
                    }
                    .onChange(of: globals.showPlayerControls ? displayedMessages : chatLog.messages) { oldValue, newValue in
                        if let lastMessage = newValue.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage, anchor: .bottom)
                            }
                        }
                    }
                    .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                        guard isPlaying else { return }
                        if currentPosition < streamLength {
                            currentPosition += 1
                            refreshMessages()
                        } else {
                            isPlaying = false // stop when end is reached
                        }
                    }
                }
            }
            if globals.showPlayerControls {
                VStack {
                    HStack {
                        Button {
                            currentPosition -= 10
                            refreshMessages()
                        } label: {
                            Label("Play/Pause", systemImage: "backward")
                                .labelStyle(.iconOnly)
                        }
                        .controlSize(.large)
                        Button {
                            isPlaying.toggle()
                            if (isPlaying) {
                                
                            } else {
                                
                            }
                        } label: {
                            Label(isPlaying ? "Pause" : "Play", systemImage: isPlaying ? "pause" : "play")
                                    .labelStyle(.iconOnly)
                        }
                        .controlSize(.large)
                        Button {
                            currentPosition += 10
                            refreshMessages()
                        } label: {
                            Label("Play/Pause", systemImage: "forward")
                                .labelStyle(.iconOnly)
                        }
                        .controlSize(.large)
                    }
                    Slider(value: $currentPosition, in: (0...streamLength)) {} minimumValueLabel: {
                        Text(Duration(secondsComponent: Int64(currentPosition), attosecondsComponent: 0).formatted())
                    } maximumValueLabel: {
                        Text(Duration(secondsComponent: Int64(streamLength), attosecondsComponent: 0).formatted())
                    } onEditingChanged: { isEditing in
                        if !isEditing {
                            refreshMessages()
                        }
                    }
                }
                .padding()
            }
        }
        .overlay(alignment: .topLeading) {
            if let streamName = chatLog.streamName {
                StreamInfoView(streamName: streamName, channelName: chatLog.channelName)
            }
        }
    }
    
    func refreshMessages() {
        displayedMessages = chatLog.messages.filter { message in
            message.time <= Int(currentPosition)
        }.suffix(200)
    }
}

#Preview {
    ContentView(chatLog: ChatLog(
        streamName: "Example STREAM NAME - !drops",
        channelName: "Twitch",
        messages: [
            Message(time: 0, username: "owl_claw92", message: "FINALLY"),
            Message(time: 2, username: "andreimonty", message: "@og_andy2k KEK JAJJAJADGGJAJJA"),
            Message(time: 4, username: "rosaliaporro", message: "live?"),
            Message(time: 5, username: "bocadillo_de_escombros", message: "ey"),
            Message(time: 6, username: "buzzlightyeahhh", message: "yo estoy con mi bigoton facha, mi camiseta de tirantes, pantalones desabrochaos y echar Patras en el sofá esperando"),
            Message(time: 9, username: "locugg", message: "OOOO"),
            Message(time: 13, username: "pedrocuboo", message: "vamonoooo"),
        ],
    ))
    .environment(Globals())
}
