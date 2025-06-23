//
//  SevenTVService.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 15/6/25.
//

import Foundation
import SwiftSevenTV
import SwiftUI

struct Emote {
    let name: String
    let image: Image?
}

struct SevenTVService {
    private static let client = SevenTVClient()
    
    static var emotes: Dictionary<String, [ChatRewind.Emote]> = [:]
    
    static func loadEmotes(forChannel: String) async {
        let clientId = Bundle.main.infoDictionary?["TWITCH_CLIENT_ID"] as? String ?? ""
        let clientSecret = Bundle.main.infoDictionary?["TWITCH_CLIENT_SECRET"] as? String ?? ""
        
        if let channelId = try? await TwitchService(clientId: clientId, clientSecret: clientSecret).getUserId(fromUsername: forChannel) {
            let response = try? await client.getEmotes(userID: channelId)
            if let response {
                print("There are \(response.count) emotes available for channel \(forChannel).")
                emotes.updateValue([], forKey: forChannel)
                print("Loaded emotes reset.")
                for emote in response {
                    let emote = await Emote(name: emote.name, image: imageFromRemoteURL(emote.url))
                    emotes[forChannel]?.append(emote)
                    print("Emote \"\(emote.name)\" loaded. \(emotes[forChannel]?.count ?? 0) emotes loaded in total.")
                }
                print("Finished loading 7TV emotes.")
            } else {
                print("No response from 7TV.")
                return
            }
        }
    }
    
    static func getEmoteFromLoad(_ emote: String, forChannel: String) -> Image? {
        return emotes[forChannel]?.first {
            $0.name == emote
        }?.image
    }
    
    private static func imageFromRemoteURL(_ url: URL) async -> Image? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            #if canImport(UIKit)
            if let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
            }
            #elseif canImport(AppKit)
            if let nsImage = NSImage(data: data) {
                return Image(nsImage: nsImage)
            }
            #endif

            return nil
        } catch {
            return nil
        }
    }
}
