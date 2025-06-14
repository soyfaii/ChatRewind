//
//  ChatRewindDocument.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 13/6/25.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftCSV

struct ChatLog: FileDocument {
    let streamName: String?
    let channelName: String?
    let messages: [Message]

    // Gets called from the app itself
    init(streamName: String? = nil, channelName: String? = nil, messages: [Message] = []) {
        self.streamName = streamName
        self.channelName = channelName
        self.messages = messages
    }
    
    static var readableContentTypes: [UTType] { [.commaSeparatedText, UTType(filenameExtension: "chrwd")!] }
    
    // Gets called when the user opens a file from the Finder
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        let csv = try CSV<Enumerated>(string: string)
        var streamName: String? = nil
        var channelName: String? = nil
        if csv.header[0] == "meta" {
            print("detected metadata")
            csv.header.forEach { cell in
                if cell.starts(with: "stream_name=") {
                    streamName = String(cell.trimmingPrefix("stream_name="))
                }
                if cell.starts(with: "channel_name=") {
                    channelName = String(cell.trimmingPrefix("channel_name="))
                }
            }
        }
        self.streamName = streamName
        self.channelName = channelName
        messages = csv.rows.compactMap { row in
            if let time = Int(row[0]) {
                // We continue because the row has a timestamp
                return Message(time: time, username: row[1], userColor: Color(hex: row[2]), message: row[3])
            } else {
                return nil
            }
        }
    }
    
    // Gets called when the user saves a file
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        // We don't want that as this app just reads but the compiler would complain
        // if we didn't add this so we just throw an error
        throw CocoaError(.fileWriteNoPermission)
    }
}
