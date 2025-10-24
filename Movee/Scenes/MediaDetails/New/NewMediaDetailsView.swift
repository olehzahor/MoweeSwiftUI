//
//  NewMediaDetailsView.swift
//  Movee
//
//  Created by Oleh on 23.10.2025.
//

import SwiftUI

struct NewMediaDetailsView: View {
    @StateObject var viewModel: NewMediaDetailsViewModel
    
    @State private var isScrolledDown: Bool = false
    @State private var headerSize: CGSize = .zero
    
    private var context: AsyncLoadingContext<MediaDetailsSection> {
        viewModel.sectionsContext
    }
    // TODO: make context configurable extension for .hideWhen and .isLoading; using just: .section(.related, context: context)
    // TODO: decouple views from concrete DataModels
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
                            NewMediaTaglineView(tagline: viewModel.media?.tagline)
                                .loading(context[.details].isAwaitingData)
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                                                
                        NewMediaVideosCarouselView(videos: viewModel.videos ?? [])
                            .loadingContext(context, section: .videos, reloader: viewModel)
                        
                        NewMediasSectionView(
                            section: viewModel.mediaSections[.seasons],
                            seasons: viewModel.seasons,
                            media: viewModel.media)
                        .loadingContext(context, section: .seasons, reloader: viewModel)
                                                
                        PersonsSectionView(persons: viewModel.credits)
                            .hideWhen(context[.credits].isEmpty)
                                                
                        NewMediasSectionView(
                            section: viewModel.mediaSections[.related],
                            medias: viewModel.related)
                        .loadingContext(context, section: .related, reloader: viewModel)
                        
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)
                        
                        NewMediasSectionView(section: <#T##NewMediasSection?#>, medias: <#T##[Media]?#>)
                        
                        MediasSectionView(
                            section: MediasSection(title: viewModel.collection?.name ?? ""),
                            medias: viewModel.collection?.medias,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.collection) }
                        )
                        .hideWhen(context[.collection].isEmpty)

                        Group {
                            Text("Reviews")
                                .textStyle(.sectionTitle)
                            MediaReviewsCarouselView(reviews: viewModel.reviews ?? [])
                        }
                        .hideWhen(context[.reviews].isLoading || context[.reviews].isEmpty)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .animation(.default, value: context)
            .onFirstAppear {
                viewModel.fetchInitialData()
            }
            .onScrollGeometryChange(for: CGFloat.self, of: \.contentOffset.y) { _, newValue in
                isScrolledDown = newValue >= 1
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    if let isInWatchlist = viewModel.isInWatchlist {
//                        Button {
//                            viewModel.toggleWatchlist()
//                        } label: {
//                            Image(systemName: isInWatchlist ? "bookmark.slash" : "bookmark")
//                        }
//                    }
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
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(media: media))
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType))
    }
}
