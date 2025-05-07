//
//  Review.swift
//  Movee
//
//  Created by user on 4/12/25.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let authorDetails: AuthorDetails
    let content: String
    let createdAt: Date
    let updatedAt: Date?
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
    
    var ratingString: String {
        guard let rating = authorDetails.rating,
              let formatted = MediaFormatterService.shared.format(rating: rating)
        else { return "" }
        // Format the numeric rating
        
        // Choose an emoji based on rating thresholds
        let emoji: String
        switch rating {
        case 7...:
            emoji = "🤩"
        case 6..<7:
            emoji = "🙂"
        case 5..<6:
            emoji = "🤔"
        default:
            emoji = "😔"
        }
        return "\(emoji)\(formatted)"
    }
    
    var detailsString: String {
        var string = "Reviewed by \(authorString)"
        if let createdAtRelativeString {
            string += " \(createdAtRelativeString)"
        }
        return string
    }
        
    var createdAtRelativeString: String? {
       MediaFormatterService.shared.format(date: createdAt, style: .relative)
    }
    
    var createdAtAbsoluteString: String? {
       MediaFormatterService.shared.format(date: createdAt, style: .full)
    }
    
    var authorAvatarURL: URL? {
        guard let avatarPath = authorDetails.avatarPath, !avatarPath.isEmpty else {
            return nil
        }
        let base = "https://image.tmdb.org/t/p/w45"
        return URL(string: base + avatarPath)
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
