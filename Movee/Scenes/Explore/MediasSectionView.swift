//
//  MediasSectionView.swift
//  Movee
//
//  Created by user on 4/5/25.
//

import SwiftUI

struct MediasSectionView: View {
    let section: MediasSection
    let medias: [Media]?
    let errorMessage: String?
    var retry: () -> Void
    var horizontalPadding: CGFloat = 20

    enum ViewState {
        case loading, loaded, error
    }
    
    var isLoading: Bool {
        medias == nil
    }

    var viewState: ViewState {
        if isLoading {
            return .loading
        } else if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return .error
        } else {
            return .loaded
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: section.title,
                isButtonHidden: viewState != .loaded) {
                AnyView(MediasListView(section: section))
            }
            Group {
                switch viewState {
                case .loading:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top) {
                            ForEach(0..<5, id: \.self) { _ in
                                MediaPosterView(media: .placeholder)
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }.padding(.horizontal, -horizontalPadding)
                case .error:
                    VStack(spacing: 10) {
                        Text("Error: \(errorMessage ?? "")")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry", action: retry)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                case .loaded:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top) {
                            ForEach(medias ?? []) { media in
                                NavigationLink {
                                    MediaDetailsView(media: media)
                                } label: {
                                    MediaPosterView(media: media)
                                }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }.padding(.horizontal, -horizontalPadding)
                }
            }.animation(.easeOut, value: viewState)
        }
    }
}

// MARK: - MediaPerson placeholder
extension Media {
    static let placeholder = Media(
        id: -1,
        mediaType: .movie,
        title: .placeholder(.short),
        originalTitle: "",
        tagline: "",
        overview: "",
        posterPath: nil,
        backdropPath: nil,
        popularity: 0,
        voteAverage: 0,
        voteCount: 0,
        releaseDate: nil,
        genreIDs: [],
        genres: nil,
        extra: nil)
}
