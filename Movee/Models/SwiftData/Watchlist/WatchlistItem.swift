//
//  WatchlistItem.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import SwiftData

@Model
final class WatchlistItem: Sendable {
    var media: Media
    var added: Date
    
    init(media: Media) {
        self.media = media
        self.added = Date()
    }
}
