//
//  WatchlistItem.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import SwiftData

@Model
final class WatchlistItem {
    var media: StoredMedia
    var added: Date

    init(media: StoredMedia) {
        self.media = media
        self.added = Date()
    }
}
