//
//  ReviewView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import UIKit

extension ReviewView {
    struct Data {
        let mediaTitle: String
        let authorAvatarURL: URL?
        let authorString: String
        let createdAtAbsoluteString: String?
        let content: String
    }
}

extension ReviewView.Data {
    init(mediaTitle: String, review: Review) {
        self.mediaTitle = mediaTitle
        self.authorAvatarURL = review.authorAvatarURL
        self.authorString = review.authorString
        self.createdAtAbsoluteString = review.createdAtAbsoluteString
        self.content = review.content
    }
}
