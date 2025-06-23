//
//  TwitchService.swift
//  ChatRewind
//
//  Created by Lucas Rubio on 23/6/25.
//

import Foundation

protocol TwitchServiceProtocol {
    func getUserId(fromUsername: String) async throws -> String
}

final class TwitchService: TwitchServiceProtocol {
    private let clientId: String
    private let clientSecret: String
    private var tokenInfo: (token: String, expiresAt: Date)?

    init(clientId: String, clientSecret: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
    }

    private func fetchOauthToken() async throws -> String {
        let url = URL(string: "https://id.twitch.tv/oauth2/token?client_id=\(clientId)&client_secret=\(clientSecret)&grant_type=client_credentials")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TwitchError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw TwitchError.httpError(statusCode: httpResponse.statusCode)
        }
        let processedResponse: OAuthResponse
        do {
            processedResponse = try JSONDecoder().decode(OAuthResponse.self, from: data)
        } catch {
            throw TwitchError.parsingError
        }
        let expiry = Date().addingTimeInterval(TimeInterval(processedResponse.expiresIn))
        tokenInfo = (processedResponse.accessToken, expiry)
        return processedResponse.accessToken
    }

    private func getValidToken() async throws -> String {
        if let token = tokenInfo, token.expiresAt > Date() {
            return token.token
        }
        return try await fetchOauthToken()
    }

    func getUserId(fromUsername: String) async throws -> String {
        let oauthToken = try await getValidToken()
        let url = URL(string: "https://api.twitch.tv/helix/users?login=\(fromUsername)")!
        let headers: [String: String] = [
            "Authorization": "Bearer \(oauthToken)",
            "Client-Id": clientId
        ]
        var request = URLRequest(url: url)
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TwitchError.invalidResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw TwitchError.httpError(statusCode: httpResponse.statusCode)
        }
#if DEBUG
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Twitch API response: \(jsonString)")
        }
#endif
        let processedResponse: TwitchResponse
        do {
            processedResponse = try JSONDecoder().decode(TwitchResponse.self, from: data)
        } catch {
            throw TwitchError.parsingError
        }
        guard let userId = processedResponse.data.first?.id else {
            throw TwitchError.userNotFound
        }
        return userId
    }
}

fileprivate struct OAuthResponse: Decodable {
    var accessToken: String
    var expiresIn: Int
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

fileprivate struct TwitchResponse: Decodable {
    var data: [TwitchUser]
}

fileprivate struct TwitchUser: Decodable {
    var id: String
    var login: String
    var displayName: String
    var type: String
    var broadcasterType: String
    var description: String
    var profileImageUrl: String
    var offlineImageUrl: String
    var viewCount: Int
    var email: String?
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case displayName = "display_name"
        case type
        case broadcasterType = "broadcaster_type"
        case description
        case profileImageUrl = "profile_image_url"
        case offlineImageUrl = "offline_image_url"
        case viewCount = "view_count"
        case email
        case createdAt = "created_at"
    }
}

enum TwitchError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case parsingError
    case userNotFound
}
