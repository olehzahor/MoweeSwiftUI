//
//  NewMediaDetailsView.swift
//  Movee
//
//  Created by Oleh on 23.10.2025.
//

import SwiftUI

struct NewMediaDetailsView: View {
    @State private var viewModel: NewMediaDetailsViewModel
    @State private var isHeaderVisible: Bool = true
    
    private var navigationTitle: String {
        isHeaderVisible ? "" : viewModel.media?.title ?? ""
    }
            
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                setupStretchyHeader()
                LazyVStack(alignment: .leading, spacing: 16) {
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
        viewModel = NewMediaDetailsViewModel(media: media)
    }
    
    init(mediaID: Int, mediaType: MediaType) {
        viewModel = NewMediaDetailsViewModel(mediaID: mediaID, mediaType: mediaType)
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
                .loading(viewModel.sectionsContext[.details].isAwaitingData)
            DescriptionView(text: viewModel.media?.overview)
                .loading(viewModel.media == nil)
        }
    }
    
    @ViewBuilder
    func setupVideosSection() -> some View {
        SectionView.trailers(viewModel.videos)
            .loadingState(viewModel, section: .videos)
    }

    @ViewBuilder
    func setupReviewsSection() -> some View {
        SectionView.reviews(viewModel.reviews)
            .loadingState(viewModel, section: .reviews)
    }
    
    @ViewBuilder
    func setupSeasonsSection() -> some View {
        SectionView.seasons(
            viewModel.seasons.items,
            media: viewModel.media,
            section: viewModel.seasons.section
        ).loadingState(viewModel, section: .seasons)
    }
    
    @ViewBuilder
    func setupCastAndCrewSection() -> some View {
        SectionView.castAndCrew(viewModel.credits)
            .loadingState(viewModel, section: .credits)
    }
    
    @ViewBuilder
    func setupRelatedSection() -> some View {
        SectionView.medias(
            viewModel.related.items,
            section: viewModel.related.section)
        .loadingState(viewModel, section: .related)
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
        ).loadingState(viewModel, section: .collection)
    }
}
