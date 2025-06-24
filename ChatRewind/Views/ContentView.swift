//
//  ContentView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI

struct ContentView: View {	
    @Environment(Globals.self) private var globals
    @AppStorage("showSevenTvEmotes") private var showSevenTvEmotes = false
    @AppStorage("maxDisplayedMessagesCount") private var maxDisplayedMessagesCount = 200
    
    var chatLog: ChatLog
    
    @State private var displayedMessages: [Message] = []
    
    @State private var referenceDate: Date? = nil
    @State private var currentPosition: TimeInterval = TimeInterval(0)
    
    @State private var isPlaying: Bool = false
    
    var streamLength: TimeInterval {
        TimeInterval(chatLog.messages.last?.time ?? 0)
    }
    
    @State private var isLoadingEmotes = false
    
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
                            MessageView(message: message, emotesReferenceChannel: chatLog.channelName ?? "")
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
                    .onReceive(Timer.publish(every: 1/120, on: .main, in: .common).autoconnect()) { _ in handlePlaybackTick() }
                    .onChange(of: currentPosition, handlePlayerPositionChange)
                }
            }
            if globals.showPlayerControls {
                PlayerControlsView(isPlaying: $isPlaying, currentPlayerPosition: $currentPosition, totalStreamLength: streamLength)
            }
        }
        .overlay(alignment: .topLeading) {
            VStack(spacing: 0) {
                if let streamName = chatLog.streamName {
                    StreamInfoView(streamName: streamName, channelName: chatLog.channelName)
                    Divider()
                }
                if isLoadingEmotes {
                    ProgressView("Loading Emotes…")
                        .progressViewStyle(.linear)
                        .controlSize(.small)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                    Divider()
                }
            }
            .background(.ultraThinMaterial)
            
        }
        .task {
            if showSevenTvEmotes {
                withAnimation {
                    isLoadingEmotes = true
                }
                await SevenTVService.loadEmotes(forChannel: chatLog.channelName ?? "")
                withAnimation {
                    isLoadingEmotes = false
                }
            }
        }
    }
    
    func handlePlaybackTick() {
        if isPlaying {
            // The player is now active;
            // We update the screen
            if let referenceDate {
                // The chat log is being played;
                // We update the current visual position
                currentPosition = Date.now.timeIntervalSince1970 - referenceDate.timeIntervalSince1970
                if currentPosition >= streamLength {
                    // The log arrived to the end;
                    // We stop the player
                    isPlaying = false
                }
            } else {
                // The chat log is getting resumed from pause;
                // We must readjust the reference date
                referenceDate = .now.addingTimeInterval(-currentPosition)
            }
        } else {
            // The player is paused;
            // We stop every counting
            referenceDate = nil
        }
    }
    
    func handlePlayerPositionChange(_ previousValue: TimeInterval, _ newValue: TimeInterval) {
        let previousSecond = previousValue.rounded(.down)
        let currentSecond = newValue.rounded(.down)
        
        let isSameSecond = previousSecond == currentSecond
        let isNextSecond = previousSecond + 1 == currentSecond
        
        if !isSameSecond {
            // The time in the stream changed;
            // We must refresh the displayed chat
            refreshMessages()
            if !isNextSecond {
                // The change was done by the user; not automatically;
                // We must adjust the reference date
                referenceDate = referenceDate?.addingTimeInterval(previousValue - newValue)
            }
        }
    }
    
    func refreshMessages() {
        displayedMessages = chatLog.messages.filter { message in
            message.time <= Int(currentPosition)
        }.suffix(maxDisplayedMessagesCount)
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
