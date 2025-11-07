//
//  MediaReviewsCarouselView.swift
//  Movee
//
//  Created by user on 4/25/25.
//


import SwiftUI
import Combine

struct MediaReviewsCarouselView: View {
    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    
    var reviews: [Review]
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
