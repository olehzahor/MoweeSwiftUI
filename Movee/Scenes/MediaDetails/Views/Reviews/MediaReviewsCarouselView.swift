//
//  MediaReviewsCarouselView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI
import Combine

struct MediaReviewsCarouselView: View {
    typealias OnSelectClosure = (Review) -> Void

    @Environment(\.carouselPadding) private var horizontalPadding: CGFloat
    @Environment(\.placeholder) private var placeholder: Bool
    @Environment(\.coordinator) private var coordinator

    private let _reviews: [Review]
    private let onSelect: OnSelectClosure?
    
    var reviews: [Review] {
        placeholder ? [.placeholder, .placeholder] : _reviews
    }
    
    func handleSelection(_ review: Review) {
        if let onSelect {
            onSelect(review)
        } else if let coordinator {
            coordinator.present(.review("", review))
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(reviews) { review in
                    MediaReviewView(data: .init(review))
                        .containerRelativeFrame(.horizontal)
                        .onTapGesture {
                            handleSelection(review)
                        }
                        .frame(height: 250)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .padding(.horizontal, -horizontalPadding)
        .fallible()
    }
        
    init(reviews: [Review], onSelect: OnSelectClosure? = nil) {
        self._reviews = reviews
        self.onSelect = onSelect
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
