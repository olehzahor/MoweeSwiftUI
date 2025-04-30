//
//  MediaDetailsView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine

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
                            items: viewModel.seasons?.compactMap { .init(season: $0) },
                            errorMessage: nil,
                            retry: { viewModel.fetchRelated() }
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
