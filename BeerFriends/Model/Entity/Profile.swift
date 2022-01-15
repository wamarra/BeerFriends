//
//  UserProfile.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id: String = UUID().uuidString
    var uid: String?
    var email: String?
    var name: String?
    var phone: String?
    var statusMessage: String?
    var photoURL: URL?
    var favoriteImagesURL: [URL]?
    var galleryImagesURL: [URL]?
    var searchTerms: [String]?
    var followers: [String]?
    var following: [String]?
    var invitationsReceived: [String]?
    var invitationsSent: [String]?
    
    var encoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static func with(_ data: [String: Any]) throws -> Profile? {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(Profile.self, from: jsonData)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case name
        case phone
        case statusMessage
        case photoURL
        case favoriteImagesURL
        case galleryImagesURL
        case searchTerms
        case followers
        case following
        case invitationsReceived
        case invitationsSent
    }
}
