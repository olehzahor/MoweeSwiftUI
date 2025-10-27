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
    @State private var appearTime: Date?

    private var context: AsyncLoadingContext<MediaDetailsSection> {
        viewModel.sectionsContext
    }

    private var shouldAnimate: Bool {
        guard let appearTime else { return false }
        return Date().timeIntervalSince(appearTime) > 0.5
    }
    
    @ViewBuilder
    private func setupReviewsSection() -> some View {
        SectionView {
            NewMediaReviewsCarouselView(reviews: viewModel.reviews ?? [], horizontalPadding: 20)
        }.loadingContext(context, section: .reviews, reloader: viewModel)
    }

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
                            section: viewModel.seasons.section,
                            seasons: viewModel.seasons.items,
                            media: viewModel.media)
                        .loadingContext(context, section: .seasons, reloader: viewModel)
                                                
                        NewPersonsSectionView(persons: viewModel.credits)
                            .loadingContext(context, section: .credits, reloader: viewModel)
                                                                        
                        NewMediasSectionView(
                            section: viewModel.related.section,
                            medias: viewModel.related.items)
                        .loadingContext(context, section: .related, reloader: viewModel)
                        // TODO: Use generic SectionView instead of creating a class...
                        SectionHeaderView(title: "Facts")
                        MediaFactsView(facts: media.facts)
                                                
                        NewMediasSectionView(
                            section: viewModel.collection.section,
                            medias: viewModel.collection.items)
                        .loadingContext(context, section: .collection, reloader: viewModel)

//                        NewMediaReviewsSectionView(reviews: viewModel.reviews)
//                            .loadingContext(context, section: .reviews, reloader: viewModel)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .animation(shouldAnimate ? .default : nil, value: context)
            .onFirstAppear {
                appearTime = Date()
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
