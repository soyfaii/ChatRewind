//
//  TwitchServiceTests.swift
//  ChatRewindTests
//
//  Created by Lucas Rubio on 23/6/25.
//

import Foundation
import Testing
@testable import ChatRewind

struct TwitchServiceTests {

    @Test func getUserId() async throws {
        let clientId = Bundle.main.infoDictionary?["TWITCH_CLIENT_ID"] as? String ?? ""
        let clientSecret = Bundle.main.infoDictionary?["TWITCH_CLIENT_SECRET"] as? String ?? ""
        
        print(clientId)
        print(clientSecret)
        
        let twitch = TwitchService(clientId: clientId, clientSecret: clientSecret)
        
        let SoyFaii = try await twitch.getUserId(fromUsername: "SoyFaii")
        #expect(SoyFaii == "415324066")
        let IlloJuan = try await twitch.getUserId(fromUsername: "IlloJuan")
        #expect(IlloJuan == "90075649")
        let alexelcapo = try await twitch.getUserId(fromUsername: "alexelcapo")
        #expect(alexelcapo == "36138196")
        let none = try? await twitch.getUserId(fromUsername: "")
        #expect(none == nil)
    }

}
