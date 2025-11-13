//
//  NewMediaReviewsCarouselView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI
import Combine

struct NewMediaReviewsCarouselView: View {
    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    
    private let _reviews: [Review]
    @State private var selectedReview: Review? = nil
    
    var reviews: [Review] {
        placeholder ? [.placeholder, .placeholder] : _reviews
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(reviews) { review in
                    MediaReviewView(review: review)
                        .containerRelativeFrame(.horizontal)
                        .onTapGesture {
                            selectedReview = review
                        }
                        .frame(height: 250)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .padding(.horizontal, -horizontalPadding)
        .sheet(item: $selectedReview) { review in
            ReviewView(mediaTitle: "Hello there", review: review)
        }
    }
    
    init(reviews: [Review]) {
        self._reviews = reviews
    }
}

// MARK: - Review placeholder
extension Review {
    static let placeholder = Review(
        id: "placeholder",
        author: "##########",
        authorDetails: AuthorDetails(
            name: "##########",
            username: "##########",
            avatarPath: nil,
            rating: nil
        ),
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        createdAt: Date(),
        updatedAt: nil,
        url: ""
    )
}
