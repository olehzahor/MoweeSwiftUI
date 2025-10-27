//
//  NewMediaReviewsCarouselView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI
import Combine

struct NewMediaReviewsCarouselView: View {
    var reviews: [Review]
    var horizontalPadding: CGFloat = 20
    @State private var selectedReview: Review? = nil
    
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
}

// MARK: - Loadable conformance
extension NewMediaReviewsCarouselView: LoadableView {
    func loadingView() -> some View {
        Self(
            reviews: [.placeholder, .placeholder],
            horizontalPadding: horizontalPadding
        )
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

// MARK: - Failable conformance
extension NewMediaReviewsCarouselView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
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
