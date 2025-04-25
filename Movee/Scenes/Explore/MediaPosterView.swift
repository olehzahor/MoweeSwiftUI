//
//  MediaPosterView.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import SwiftUI
import Combine

struct MediaRatingView: View {
    var rating: Double
    
    private var backgroundColor: Color {
        if rating >= 7.0 {
            return .green
        } else if rating >= 5.0 {
            return .yellow
        } else {
            return .red
        }
    }

    var body: some View {
        Text(String(format: "%.1f", rating))
            .font(.system(size: 8))
            .foregroundStyle(.black)
            .padding(.horizontal, 4)
            .background(backgroundColor.opacity(0.8))
            .clipShape(.capsule)
    }
}


struct CircularProgressBar: View {
    /// progress should be a value between 0.0 (0%) and 1.0 (100%)
    var progress: CGFloat
    
    /// The color of the progress ring.
    var color: Color = .green

    /// Optional: A multiplier to adjust the line width relative to the view size.
    /// For example, a multiplier of 0.1 means the line width is 10% of the circle’s size.
    var lineWidthMultiplier: CGFloat = 0.1

    var body: some View {
        GeometryReader { geometry in
            // Use the smallest side to ensure the circle remains fully visible.
            let size = min(geometry.size.width, geometry.size.height)
            let lineWidth = size * lineWidthMultiplier

            ZStack {
                // Background circle – the unfilled part.
                Circle()
                    .stroke(
                        color.opacity(0.2),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                
                // Foreground circle – the filled progress portion.
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: progress)
                
                // Centered text displaying the percentage.
                HStack(spacing: 0) {
                    Text(verbatim: "\(Int(progress * 100))")
                        .font(.system(size: size * 0.35, weight: .bold))
                    Text("%")
                        .font(.system(size: size * 0.3, design: .monospaced))
                }
            }
            // Ensure the ZStack fits within the computed size.
            .frame(width: size, height: size)
        }
        // Optionally, you can fix a minimum size for this view
        // or let it expand to the available space.
    }
}

struct MediaPosterView: View {
    let posterURL: URL?
    let title: String?
    let rating: Double?
    
    // Initializer using poster URL and title
    init(posterURL: URL?, title: String? = nil, rating: Double? = nil) {
        self.posterURL = posterURL
        self.title = title
        self.rating = rating
    }
    
    // Initializer using a Movie object
    init(media: Media) {
        self.posterURL = media.posterURL
        self.title = media.title
        self.rating = media.voteAverage
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                AsyncImageView(
                    url: posterURL,
                    width: 100,
                    height: 150,
                    cornerRadius: 8,
                    placeholder: .init(resource: .imageMalePersonPlaceholder)
                )
                if let rating, rating > 0 {
                    MediaRatingView(rating: rating)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
            
            if let title {
                Text(title)
                    .textStyle(.mediaSmallTitle)
            }
        }
        .frame(width: 100)
        .tint(.primary)
    }
}

struct MediaPosterView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPosterView(posterURL: URL(string: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=myke-simon-atsUqIm3wxo-unsplash.jpg&w=640"), title: "Beneath the Silence, a Storm Awaits", rating: 7.3)
    }
}
