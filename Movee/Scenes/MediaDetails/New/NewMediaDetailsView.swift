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
    
    private var navigationTitle: String {
        isHeaderVisible ? "" : viewModel.media?.title ?? ""
    }
            
    var body: some View {
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
        //.postponedAnimation(0.5, .default, value: context)
        .onFirstAppear {
            viewModel.fetchInitialData()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                WatchlistButton(watchlistManager: viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(navigationTitle)
        .ignoresSafeArea(edges: .top)
    }
    
    init(media: Media) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(media: media))
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        _viewModel = StateObject(wrappedValue: NewMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType))
    }
}

private extension NewMediaDetailsView {
    @ViewBuilder
    func setupStretchyHeader() -> some View {
        BackdropStretchyHeaderView(backdropURL: viewModel.media?.backdropURL)
            .aspectRatio(4/3, contentMode: .fit)
            .padding(.bottom, 80)
            .overlay(alignment: .bottom) {
                MediaDetailedInfoView(media: viewModel.media ?? .placeholder)
                    .loading(viewModel.media == nil)
                    .onScrollVisibilityChange { isVisible in
                        isHeaderVisible = isVisible
                    }
            }
    }

    @ViewBuilder
    func setupDetailsSection() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            NewMediaTaglineView(tagline: viewModel.media?.tagline)
                .loading(context[.details].isAwaitingData)
            DescriptionView(text: viewModel.media?.overview)
                .loading(viewModel.media == nil)
        }
    }
    
    @ViewBuilder
    func setupVideosSection() -> some View {
        SectionView.trailers(viewModel.videos)
            .loadingContext(context, section: .videos, reloader: viewModel)
    }

    @ViewBuilder
    func setupReviewsSection() -> some View {
        SectionView.reviews(viewModel.reviews)
            .loadingContext(context, section: .reviews, reloader: viewModel)
    }
    
    @ViewBuilder
    func setupSeasonsSection() -> some View {
        SectionView.seasons(
            viewModel.seasons.items,
            media: viewModel.media,
            section: viewModel.seasons.section
        ).loadingContext(context, section: .seasons, reloader: viewModel)
    }
    
    @ViewBuilder
    func setupCastAndCrewSection() -> some View {
        SectionView.castAndCrew(viewModel.credits)
            .loadingContext(context, section: .credits, reloader: viewModel)
    }
    
    @ViewBuilder
    func setupRelatedSection() -> some View {
        SectionView.medias(
            viewModel.related.items,
            section: viewModel.related.section)
        .loadingContext(context, section: .related, reloader: viewModel)
    }
    
    @ViewBuilder
    func setupFactsSection() -> some View {
        if let facts = viewModel.media?.facts {
            SectionHeaderView(title: "Facts")
            MediaFactsView(facts: facts)
        }
    }
    
    @ViewBuilder
    func setupCollectionSection() -> some View {
        SectionView.medias(viewModel.collection.items,
                           section: viewModel.collection.section
        ).loadingContext(context, section: .collection, reloader: viewModel)
    }
}
