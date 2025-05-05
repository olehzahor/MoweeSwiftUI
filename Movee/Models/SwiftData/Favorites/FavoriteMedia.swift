//
//  FavoriteMedia.swift
//  Movee
//
//  Created by user on 5/5/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteMedia: Sendable {
    var added: Date
    var media: StoredMedia
    
    init(media: StoredMedia) {
        self.added = Date()
        self.media = media
    }
}
