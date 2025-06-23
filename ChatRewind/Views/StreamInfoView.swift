//
//  StreamInfoView.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 14/6/25.
//

import SwiftUI

struct StreamInfoView: View {
    var streamName: String
    var channelName: String? = nil
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(streamName)
                    .font(.headline)
                if let channelName = channelName {
                    Text(channelName)
                        .font(.subheadline)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StreamInfoView(streamName: "Stream Name", channelName: "Channel Name")
}
