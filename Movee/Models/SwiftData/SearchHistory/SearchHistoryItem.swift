//
//  SearchHistoryItem.swift
//  Movee
//
//  Created by user on 5/15/25.
//

import Foundation
import SwiftData

@Model
final class SearchHistoryItem {
    var media: StoredMedia
    var added: Date

    init(media: StoredMedia) {
        self.media = media
        self.added = Date()
    }
}
