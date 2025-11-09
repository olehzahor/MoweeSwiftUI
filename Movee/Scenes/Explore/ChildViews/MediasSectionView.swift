//
//  MediasSectionView.swift
//  Movee
//
//  Created by user on 4/5/25.
//

import SwiftUI

struct MediasSectionView: View {
    let section: MediasSection
    let medias: [MediaUIModel]?
    let errorMessage: String?
    var retry: (() -> Void)?
    var horizontalPadding: CGFloat

    enum ViewState {
        case loading, loaded, error
    }
    
    var isLoading: Bool {
        medias == nil
    }

    var viewState: ViewState {
        if isLoading {
            return .loading
        } else if let errorMessage = errorMessage, !errorMessage.isEmpty {
            return .error
        } else {
            return .loaded
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: section.title,
                isButtonHidden: viewState != .loaded || section.publisherBuilder == nil) {
                    AnyView(EmptyView())
                //AnyView(MediasListView(section: section))
            }
            Group {
                switch viewState {
                case .loading:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top) {
                            ForEach(0..<5, id: \.self) { _ in
                                MediaPosterView(.placeholder)
                                    .redacted(reason: .placeholder)
                                    .shimmering()
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }.padding(.horizontal, -horizontalPadding)
                case .error:
                    VStack(spacing: 10) {
                        Text("Error: \(errorMessage ?? "")")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry", action: retry ?? {})
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                case .loaded:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top) {
                            ForEach(medias ?? []) { media in
                                NavigationLink {
                                    switch media.object {
                                    case .media(let media):
                                        NewMediaDetailsView(media: media)
                                    case .season(let season, let media):
                                        SeasonDetailsView(tvShowID: media.id, season: season)
                                    default:
                                        EmptyView()
                                    }
                                } label: {
                                    MediaPosterView(media)
                                }
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                    }.padding(.horizontal, -horizontalPadding)
                }
            }.animation(.easeOut, value: viewState)
        }
    }
    
    // MARK: - Designated Initializer

    init(
        section: MediasSection,
        items: [MediaUIModel]?,
        errorMessage: String? = nil,
        retry: (() -> Void)? = nil,
        horizontalPadding: CGFloat = 20
    ) {
        self.section = section
        self.medias = items
        self.errorMessage = errorMessage
        self.retry = retry
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - Convenience Initializers
extension MediasSectionView {
    init(
        section: MediasSection,
        medias: [Media]?,
        errorMessage: String? = nil,
        retry: (() -> Void)? = nil,
        horizontalPadding: CGFloat = 20
    ) {
        self.init(
            section: section,
            items: medias?.map { .init(media: $0) },
            errorMessage: errorMessage,
            retry: retry,
            horizontalPadding: horizontalPadding
        )
    }

    init(
        section: MediasSection,
        seasons: [Season]?,
        media: Media?,
        errorMessage: String? = nil,
        retry: (() -> Void)? = nil,
        horizontalPadding: CGFloat = 20
    ) {
        let items: [MediaUIModel]? = {
            guard let media = media else { return nil }
            return seasons?.map { .init(season: $0, media: media) }
        }()

        self.init(
            section: section,
            items: items,
            errorMessage: errorMessage,
            retry: retry,
            horizontalPadding: horizontalPadding
        )
    }
}
