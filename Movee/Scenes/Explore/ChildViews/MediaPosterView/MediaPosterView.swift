//
//  MediaPosterView.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import SwiftUI
import Combine

struct MediaPosterView: View {
    let model: MediaUIModel
    
    let width: CGFloat = 100
    let aspectRatio: CGFloat = 2/3

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                AsyncImageView(
                    url: model.posterURL,
                    cornerRadius: 8,
                    placeholder: model.placeholder
                )
                .aspectRatio(aspectRatio, contentMode: .fit)
                if let rating = model.rating, rating > 0 {
                    MediaRatingView(rating: rating)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
            if let title = model.title {
                Text(title)
                    .textStyle(.mediaSmallTitle)
                    .lineLimit(model.subtitle == nil ? 2...3 : 0...3)
            }
            if let subtitle = model.subtitle {
                Text(subtitle)
                    .textStyle(.smallSubtitle)
                    .lineLimit(2...3)
            }
        }
        .frame(width: width)
        .tint(.primary)
    }
    
    init(_ data: MediaUIModel) {
        self.model = data
    }
}

struct MediaPosterView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPosterView(.init(
            id: 100,
            title: "Beneath the Silence, a Storm Awaits",
            subtitle: nil,
            posterURL: URL(string: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=myke-simon-atsUqIm3wxo-unsplash.jpg&w=640"),
            rating: 7.3,
            object: nil))
    }
}
