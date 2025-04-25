//
//  Review.swift
//  Movee
//
//  Created by user on 4/12/25.
//

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: String
    let updatedAt: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case url
    }
}

extension Review {
    var authorString: String {
        if authorDetails.name.isEmpty {
            return authorDetails.username
        } else {
            return authorDetails.name
        }
    }
}

struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}
