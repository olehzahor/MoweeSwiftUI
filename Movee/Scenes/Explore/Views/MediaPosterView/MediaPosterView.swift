//
//  MediaPosterView.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import SwiftUI
import Combine

struct MediaPosterView: View {
    let data: Data
    let config: Config

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                AsyncImageView(
                    url: data.posterURL,
                    placeholder: data.placeholder
                )
                .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                .frame(width: 100, height: 150)
                //.aspectRatio(config.aspectRatio, contentMode: .fit)
                if let rating = data.rating, rating > 0 {
                    MediaRatingView(rating: rating)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
            if config.showTitles {
                if let title = data.title {
                    Text(title)
                        .textStyle(.mediaSmallTitle)
                        .lineLimit(data.subtitle == nil ? 2...3 : 0...3)
                }
                if let subtitle = data.subtitle {
                    Text(subtitle)
                        .textStyle(.smallSubtitle)
                        .lineLimit(2...3)
                }
            }
        }
        .frame(width: config.width)
        .tint(.primary)
    }

    init(data: Data, config: Config = .default) {
        self.data = data
        self.config = config
    }

    // Convenience init for backward compatibility
    init(_ mediaUIModel: MediaUIModel, config: Config = .default) {
        self.data = Data(mediaUIModel)
        self.config = config
    }
}

// MARK: - Data
extension MediaPosterView {
    struct Data {
        let posterURL: URL?
        let rating: Double?
        let title: String?
        let subtitle: String?
        let placeholder: UIImage?

        init(
            posterURL: URL?,
            rating: Double? = nil,
            title: String? = nil,
            subtitle: String? = nil,
            placeholder: UIImage? = nil
        ) {
            self.posterURL = posterURL
            self.rating = rating
            self.title = title
            self.subtitle = subtitle
            self.placeholder = placeholder
        }

        init(_ media: MediaUIModel) {
            self.posterURL = media.posterURL
            self.rating = media.rating
            self.title = media.title
            self.subtitle = media.subtitle
            self.placeholder = media.placeholder
        }
    }
}

// MARK: - Config
extension MediaPosterView {
    struct Config {
        let width: CGFloat
        let aspectRatio: CGFloat
        let cornerRadius: CGFloat
        let showTitles: Bool

        init(
            width: CGFloat = 100,
            aspectRatio: CGFloat = 2/3,
            cornerRadius: CGFloat = 8,
            showTitles: Bool = true
        ) {
            self.width = width
            self.aspectRatio = aspectRatio
            self.cornerRadius = cornerRadius
            self.showTitles = showTitles
        }

        static let `default` = Config()
        static let row = Config(showTitles: false)
        static let grid = Config(showTitles: true)
    }
}

struct MediaPosterView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPosterView(
            data: .init(
                posterURL: URL(string: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=myke-simon-atsUqIm3wxo-unsplash.jpg&w=640"),
                rating: 7.3,
                title: "Beneath the Silence, a Storm Awaits",
                subtitle: "2024 · Action"
            )
        )
    }
}
