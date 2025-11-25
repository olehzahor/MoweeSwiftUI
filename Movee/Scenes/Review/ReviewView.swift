//
//  ReviewView.swift
//  Movee
//
//  Created by user on 4/13/25.
//

import SwiftUI
import Factory

struct ReviewView: View {
    let mediaTitle: String
    let review: Review
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    AsyncImageView(
                        url: review.authorAvatarURL,
                        placeholder: .init(resource: .imageMalePersonPlaceholder)
                    )
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading) {
                        Text("\(review.authorString)")
                            .textStyle(.mediumTitle)
                        if let createdAt = review.createdAtAbsoluteString {
                            Text(createdAt)
                                .textStyle(.mediumSubtitle)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(.init(review.content))
            }.padding()
        }
    }
}
