//
//  MediaReviewView.swift
//  Movee
//
//  Created by user on 4/25/25.
//


import SwiftUI
import Combine

struct MediaReviewView: View {
    var review: Review
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack(alignment: .leading) {
                Text(.init(review.content))
                    .textStyle(.smallText)
                Spacer()
                Divider().padding(.bottom, 8)
                HStack {
                    Text(review.ratingString)
                    Spacer()
                    Text("Reviewed by \(review.authorString) \(review.createdAtRelativeString)")
                }.foregroundStyle(.secondary)
                .textStyle(.smallText)
            }.padding()
        }
        .clipShape(.rect(cornerRadius: 8))
        .tint(.secondary)
    }
}
