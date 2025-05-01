//
//  MediaPosterView.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import SwiftUI
import Combine

struct MediaPosterView: View {
    let model: DataModel
        
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                AsyncImageView(
                    url: model.posterURL,
                    width: 100,
                    height: 150,
                    cornerRadius: 8,
                    placeholder: .init(resource: .imageMoviePlaceholder)
                )
                if let rating = model.rating, rating > 0 {
                    MediaRatingView(rating: rating)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
            
            if let title = model.title {
                Text(title)
                    .textStyle(.mediaSmallTitle)
            }
            if let subtitle = model.subtitle {
                Text(subtitle)
                    .textStyle(.smallSubtitle)
            }
        }
        .frame(width: 100)
        .tint(.primary)
    }
    
    init(_ data: DataModel) {
        self.model = data
    }
}

struct MediaPosterView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPosterView(.init(
            title: "Beneath the Silence, a Storm Awaits",
            subtitle: nil,
            posterURL: URL(string: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=myke-simon-atsUqIm3wxo-unsplash.jpg&w=640"),
            rating: 7.3,
            object: nil))
    }
}
