//
//  MediaDetailsView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine

import SwiftUI

struct MediaVideosCarouselView: View {
    let videos: [Video]
    private let horizontalPadding: CGFloat = 20

    var body: some View {
        VStack(alignment: .leading) {
            Text("Trailers")
                .textStyle(.sectionTitle)
                .padding(.bottom, 0)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    Group {
                        if videos.isEmpty {
                            ForEach(0..<3, id: \.self) { _ in
                                MediaVideoView(data: .placeholder)
                                .shimmering()
                                .disabled(true)
                            }
                        } else {
                            ForEach(videos, id: \.id) { video in
                                MediaVideoView(data: .init(video: video))
                            }
                        }
                    }.containerRelativeFrame(.horizontal)
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(videos.count <= 1)
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
            .padding(.horizontal, -horizontalPadding)
        }
    }
}

struct MediaVideoView: View {
    struct DataModel {
        var title: String
        var backdropURL: URL?
        var videoKey: String?
        
        var youtubeURL: URL? {
            guard let videoKey else { return nil }
            return URL(string: "https://www.youtube.com/embed/\(videoKey)?playsinline=1&autoplay=1&rel=0")
        }
        
        static var placeholder = Self(title: .placeholder(.short))
        
        init(title: String, backdropURL: URL? = nil, videoKey: String? = nil) {
            self.title = title
            self.backdropURL = backdropURL
            self.videoKey = videoKey
        }
        
        init(video: Video) {
            self.title = video.name
            self.backdropURL = video.thumbnailURL
            self.videoKey = video.key
        }
    }

    var data: DataModel
    
    @State private var size: CGSize = .zero
    @State private var isPlayerVisible: Bool = false
    @State private var isPlayerLoading: Bool = false

    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                AsyncImageView(url: data.backdropURL, height: size.width * 9/16)
                    .saveSize(in: $size)
                Color.secondary.opacity(0.1)
                if isPlayerLoading {
                    ProgressView()
                } else {
                    Image(systemName: "play.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
            }
            .onTapGesture {
                isPlayerVisible = true
                isPlayerLoading = true
            }
            
            if isPlayerVisible, let youtubeURL = data.youtubeURL {
                WebView(.url(youtubeURL)).onLoadingStateChanged { _, isLoading in
                    isPlayerLoading = isLoading
                }
                .opacity(isPlayerLoading ? 0 : 1)
                .animation(.easeOut, value: isPlayerLoading)
            }
        }
        .clipShape(.rect(cornerRadius: 8))
    }
}


struct MediaBackdropView: View {
    var title: String
    var backdropURL: URL?
    
    @State private var size: CGSize = .zero
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.secondary
            AsyncImageView(url: backdropURL, height: size.width * 9/16)
                .saveSize(in: $size)
                .opacity(0.9)
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .center,
                endPoint: .bottom)
            Text(title)
                .foregroundStyle(.white)
                .textStyle(.smallTitle)
                .padding()
        }.clipShape(.rect(cornerRadius: 8))
    }
}

struct MediaCollectionsCarouselView: View {
    var collections: [Collection]
    private let horizontalPadding: CGFloat = 20
    
    private func getMediasSection(for collection: Collection) -> MediasSection {
        .init(title: collection.name) { _ in
            TMDBAPIClient.shared.fetchCollection(collectionID: collection.id)
                .map { .wrap($0.parts.map({ .init(movie: $0) })) }
                .eraseToAnyPublisher()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Collections")
                .textStyle(.sectionTitle).padding(.bottom, 0)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(collections, id: \.id) { collection in
                        NavigationLink {
                            MediasListView(section: getMediasSection(for: collection))
                        } label: {
                            MediaBackdropView(
                                title: collection.name,
                                backdropURL: collection.backdropURL
                            )
                        }
                        .containerRelativeFrame(.horizontal)
                        .aspectRatio(16/9, contentMode: .fill)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollDisabled(collections.count <= 1)
            .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .padding(.horizontal, -horizontalPadding)
        }
    }
}

struct MediaDetailsView: View {
    @StateObject var viewModel: MediaDetailsViewModel
    
    @State private var isScrolledDown: Bool = false
    @State private var headerSize: CGSize = .zero
    
    var body: some View {
        if let media = viewModel.media {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    BackdropStrechyHeaderView(backdropURL: media.backdropURL)
                        .aspectRatio(4/3, contentMode: .fit)
                        .padding(.bottom, 80)
                        .overlay(alignment: .bottom) {
                            MediaDetailedInfoView(media: media)
                        }
                        .saveSize(in: $headerSize)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            MediaTaglineView(
                                tagline: viewModel.media?.tagline,
                                isLoading: viewModel.state.isLoading(.details)
                            )
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                        
                        MediaVideosCarouselView(videos: viewModel.videos ?? [])
                            .hideWhen(viewModel.state.isEmpty(.videos))
                        
                        MediasSectionView(
                            section: .init(title: "Seasons"),
                            items: viewModel.seasonModels,
                            errorMessage: nil,
                            retry: { viewModel.fetchRelated() }
                        ).hideWhen(
                            viewModel.media?.mediaType != .tvShow ||
                            viewModel.state.isEmpty(.seasons)
                        )
                        
                        PersonsSectionView(persons: viewModel.credits)
                            .hideWhen(viewModel.state.isEmpty(.credits))
                        
                        MediasSectionView(
                            section: viewModel.relatedSection,
                            medias: viewModel.related,
                            errorMessage: nil,
                            retry: { viewModel.fetchRelated() }
                        )
                        .hideWhen(viewModel.state.isEmpty(.related))
                        
                        if case .movie(let extra) = viewModel.media?.extra {
                            MediaCollectionsCarouselView(collections: [extra.belongsToCollection].compactMap({ $0 }))
                                .hideWhen(extra.belongsToCollection == nil)
                        }
                        
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)

                        Group {
                            Text("Reviews")
                                .textStyle(.sectionTitle)
                            MediaReviewsCarouselView(reviews: viewModel.reviews ?? [])
                        }
                        .hideWhen(viewModel.state.isLoading(.reviews) || viewModel.state.isEmpty(.reviews))
                        
                        //MediaTrailerView()
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onFirstAppear {
                viewModel.fetchInitialData()
            }
            .onScrollGeometryChange(for: CGFloat.self, of: \.contentOffset.y) { _, newValue in
                isScrolledDown = newValue >= 1
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let isInWatchlist = viewModel.isInWatchlist {
                        Button {
                            viewModel.toggleWatchlist()
                        } label: {
                            Image(systemName: isInWatchlist ? "bookmark.slash" : "bookmark")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "heart")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(isScrolledDown ? media.title : "")
            .ignoresSafeArea(edges: .top)
        } else {
            VStack {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5)
                Spacer()
            }
        }
    }
    
    init(media: Media) {
        _viewModel = StateObject(wrappedValue: MediaDetailsViewModel(media: media))
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        _viewModel = StateObject(wrappedValue: MediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType))
    }
}


struct MediaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MediaDetailsView(media: Media(movie: Movie.mock))
        }
    }
}

/*                HStack {
 Group {
     Button("IMDB") { }
     Spacer()
     Label("Lightning", systemImage: "bolt.fill")
         .labelStyle(.titleAndIcon)
     Button("👍") { }
     Button("👎") { }
 }.buttonStyle(.bordered)
}.padding(.vertical)
*/
