//
//  PlayerControlsView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 14/6/25.
//

import SwiftUI

struct PlayerControlsView: View {
    @Binding var isPlaying: Bool
    @Binding var currentPlayerPosition: TimeInterval
    var totalStreamLength: TimeInterval
    
    @State private var isEditing = false
    @State private var sliderPosition: TimeInterval = TimeInterval(0)
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if currentPlayerPosition >= 10 {
                        currentPlayerPosition -= 10
                    } else {
                        currentPlayerPosition = 0
                    }
                } label: {
                    Label(String(localized: "Backward.button", defaultValue: "Backward"), systemImage: "10.arrow.trianglehead.counterclockwise")
                        .labelStyle(.iconOnly)
                }
                .controlSize(.large)
                Button {
                    isPlaying.toggle()
                } label: {
                    Label(isPlaying ? String(localized: "Pause.button", defaultValue: "Pause") : String(localized: "Play.button", defaultValue: "Play"), systemImage: isPlaying ? "pause.fill" : "play.fill")
                            .labelStyle(.iconOnly)
                }
                .controlSize(.large)
                Button {
                    if currentPlayerPosition <= (totalStreamLength - 10) {
                        currentPlayerPosition += 10
                    } else {
                        currentPlayerPosition = totalStreamLength
                    }
                } label: {
                    Label(String(localized: "Forward.button", defaultValue: "Forward"), systemImage: "10.arrow.trianglehead.clockwise")
                        .labelStyle(.iconOnly)
                }
                .controlSize(.large)
            }
            .buttonStyle(.accessoryBar)
            Slider(value: $sliderPosition, in: (0...totalStreamLength)) {} minimumValueLabel: {
                Text(Duration(secondsComponent: Int64(sliderPosition), attosecondsComponent: 0).formatted())
            } maximumValueLabel: {
                Text(Duration(secondsComponent: Int64(totalStreamLength), attosecondsComponent: 0).formatted())
            } onEditingChanged: { isEditing in
                self.isEditing = isEditing
                if !isEditing {
                    currentPlayerPosition = sliderPosition
                }
            }
            .onChange(of: currentPlayerPosition) {
                if !isEditing {
                    sliderPosition = currentPlayerPosition
                }
            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var isPlaying = false
    @Previewable @State var currentPlayerPosition = TimeInterval(0)
    var totalStreamLength = TimeInterval(75)
    PlayerControlsView(isPlaying: $isPlaying, currentPlayerPosition: $currentPlayerPosition, totalStreamLength: totalStreamLength)
}
