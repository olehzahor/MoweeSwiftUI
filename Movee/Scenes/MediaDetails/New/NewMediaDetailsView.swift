//
//  NewMediaDetailsView.swift
//  Movee
//
//  Created by Oleh on 23.10.2025.
//


import SwiftUI

protocol LoadableView: View {
    associatedtype LoadingContent: View
    @ViewBuilder func loadingView() -> LoadingContent
}

protocol FailableView: View {
    associatedtype ErrorContent: View
    @ViewBuilder func errorView(error: Error, retry: (() -> Void)?) -> ErrorContent
}

struct LoadingModifier<LoadingContent: View>: ViewModifier {
    let isLoading: Bool
    let loadingContent: () -> LoadingContent

    func body(content: Content) -> some View {
        if isLoading {
            loadingContent()
        } else {
            content
        }
    }
}

struct ErrorModifier<ErrorContent: View>: ViewModifier {
    let error: Error?
    let retry: () -> Void
    let errorContent: (Error) -> ErrorContent

    func body(content: Content) -> some View {
        if let error {
            errorContent(error)
        } else {
            content
        }
    }
}

extension View where Self: LoadableView {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading) {
            self.loadingView()
        })
    }
}

extension View where Self: FailableView {
    func error(_ error: Error?, retry: @escaping () -> Void) -> some View
{
        modifier(ErrorModifier(error: error, retry: retry) { error in
            self.errorView(error: error, retry: retry)
        })
    }
}

extension View where Self: LoadableView & FailableView {
    func loading(_ isLoading: Bool, error: Error?, retry: @escaping () -> Void) -> some View {
        Group {
            if isLoading {
                modifier(LoadingModifier(isLoading: isLoading) {
                    self.loadingView()
                })
            } else if let error {
                modifier(ErrorModifier(error: error, retry: retry) { error in
                    self.errorView(error: error, retry: retry)
                })
            } else {
                self
            }
        }
    }
    
    func loadingContext<Section>(_ context: SectionsLoadingContext<Section>, section: Section, retry: @escaping () -> Void) -> some View {
        self
            .loading(context[section].isLoading, error: context[section].error, retry: retry)
            .hideWhen(context[section].isEmpty)
    }

    func loadingContext<Section, Fetcher: SectionFetchable>(
        _ context: SectionsLoadingContext<Section>,
        section: Section,
        fetcher: Fetcher
    ) -> some View where Fetcher.SectionType == Section {
        self
            .loading(context[section].isLoading, error: context[section].error) {
                fetcher.fetch(section)
            }
            .hideWhen(context[section].isEmpty)
    }
}



struct NewMediaDetailsView: View {
    @StateObject var viewModel: NewMediaDetailsViewModel
    
    @State private var isScrolledDown: Bool = false
    @State private var headerSize: CGSize = .zero
    
    private var context: SectionsLoadingContext<MediaDetailsSection> {
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
                                isLoading: context[.details].isLoading
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
