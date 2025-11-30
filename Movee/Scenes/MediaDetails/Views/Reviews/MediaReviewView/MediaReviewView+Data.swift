//
//  MediaReviewView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import Foundation

extension MediaReviewView {
    struct Data {
        let content: String
        let ratingString: String
        let detailsString: String
    }
}

extension MediaReviewView.Data {
    init(_ review: Review) {
        self.content = review.content
        self.ratingString = review.ratingString
        self.detailsString = review.detailsString
    }
}
