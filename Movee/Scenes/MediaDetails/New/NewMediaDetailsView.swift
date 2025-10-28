//
//  NewMediaDetailsView.swift
//  Movee
//
//  Created by Oleh on 23.10.2025.
//

import SwiftUI

struct NewMediaDetailsView: View {
    @StateObject var viewModel: NewMediaDetailsViewModel
    @State private var isHeaderVisible: Bool = true

    private var context: AsyncLoadingContext<MediaDetailsSection> {
        viewModel.sectionsContext
    }
    
    private var media: Media {
        viewModel.media ?? .placeholder
    }
    
    @ViewBuilder
    private func setupStretchyHeader() -> some View {
        BackdropStretchyHeaderView(backdropURL: viewModel.media?.backdropURL)
            .aspectRatio(4/3, contentMode: .fit)
            .padding(.bottom, 80)
            .overlay(alignment: .bottom) {
                MediaDetailedInfoView(media: media)
                    .loading(viewModel.media == nil)
                    .onScrollVisibilityChange { isVisible in
                        isHeaderVisible = isVisible
                    }
            }
    }

    @ViewBuilder
    private func setupDetailsSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            NewMediaTaglineView(tagline: viewModel.media?.tagline)
                .loading(context[.details].isAwaitingData)
            DescriptionView(text: viewModel.media?.overview)
                .loading(viewModel.media == nil)
        }
    }
    
    @ViewBuilder
    private func setupVideosSection() -> some View {
        SectionView.trailers(viewModel.videos)
            .loadingContext(context, section: .videos, reloader: viewModel)
    }

    @ViewBuilder
    private func setupReviewsSection() -> some View {
        SectionView.reviews(viewModel.reviews)
            .loadingContext(context, section: .reviews, reloader: viewModel)
    }
    
    @ViewBuilder
    private func setupSeasonsSection() -> some View {
        SectionView.seasons(
            viewModel.seasons.items,
            media: viewModel.media,
            section: viewModel.seasons.section
        ).loadingContext(context, section: .seasons, reloader: viewModel)
    }
    
    @ViewBuilder
    private func setupCastAndCrewSection() -> some View {
        SectionView.castAndCrew(viewModel.credits)
            .loadingContext(context, section: .credits, reloader: viewModel)
    }
    
    @ViewBuilder
    private func setupRelatedSection() -> some View {
        SectionView.medias(
            viewModel.related.items,
            section: viewModel.related.section)
        .loadingContext(context, section: .related, reloader: viewModel)
    }
    
    @ViewBuilder
    private func setupFactsSection() -> some View {
        if let facts = viewModel.media?.facts {
            SectionHeaderView(title: "Facts")
            MediaFactsView(facts: facts)
        }
    }
    
    @ViewBuilder
    private func setupCollectionSection() -> some View {
        SectionView.medias(viewModel.collection.items,
                           section: viewModel.collection.section
        ).loadingContext(context, section: .collection, reloader: viewModel)
    }
    
    var body: some View {
        //if let media = viewModel.media {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    setupStretchyHeader()
                    VStack(alignment: .leading, spacing: 16) {
                        setupDetailsSection()
                        setupVideosSection()
                        setupSeasonsSection()
                        setupCastAndCrewSection()
                        setupRelatedSection()
                        setupFactsSection()
                        setupCollectionSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .postponedAnimation(0, .default, value: context)
            .onFirstAppear {
                viewModel.fetchInitialData()
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
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(media.title).font(.headline).opacity(
                            !isHeaderVisible ? 1 : 0
                        ).animation(.default, value: isHeaderVisible)
                    }
                }
            }
            .navigationTitle(media.title)
            .ignoresSafeArea(edges: .top)
//        } else {
//            VStack {
//                Spacer()
//                ProgressView()
//                    .scaleEffect(1.5)
//                Spacer()
//            }
//        }
    }
    
    init(media: Media) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(media: media))
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType))
    }
}
