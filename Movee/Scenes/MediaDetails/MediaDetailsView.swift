//
//  MediaDetailsView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine

struct MediaCollectionView: View {
    var collection: Collection
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImageView(url: TMDBImageURLProvider.shared.url(path: collection.backdropPath, size: .w500))
            LinearGradient(
                colors: [.clear, .black.opacity(0.5)],
                startPoint: .center,
                endPoint: .bottom)
            Text(collection.name)
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
                            MediaCollectionView(collection: collection)
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
