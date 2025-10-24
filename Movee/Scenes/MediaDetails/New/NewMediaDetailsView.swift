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
    var body: some View {
        if let media = viewModel.media {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    BackdropStrechyHeaderView(backdropURL: media.backdropURL)
                        .aspectRatio(4/3, contentMode: .fit)
                        .padding(.bottom, 80)
                        .overlay(alignment: .bottom) {
                            // TODO: decouple views from concrete DataModels
                            MediaDetailedInfoView(media: media)
                        }
                        .saveSize(in: $headerSize)
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            // TODO: global isLoading?? (LoadableView protocol)
                            MediaTaglineView(
                                tagline: viewModel.media?.tagline,
                                isLoading: context[.details].isNotLoaded
                            )
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                        
                        MediaVideosCarouselView(videos: viewModel.videos ?? [])
                            .hideWhen(context[.videos].isEmpty)
                        
                        MediasSectionView(
                            section: .init(title: "Seasons"),
                            seasons: viewModel.seasons,
                            media: viewModel.media,
                            errorMessage: nil,
                            retry: { viewModel.fetch(.details) }
                        ).hideWhen(
                            context[.seasons].isEmpty
                        )
                        
                        PersonsSectionView(persons: viewModel.credits)
                            .hideWhen(context[.credits].isEmpty)
                                                
                        NewMediasSectionView(
                            section: viewModel.mediaSections[.related],
                            medias: viewModel.related)
                        .loadingContext(context, section: .related, fetcher: viewModel)

                        
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)
                        
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
