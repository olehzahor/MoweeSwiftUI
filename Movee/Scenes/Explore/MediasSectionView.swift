//
//  MediasSectionView.swift
//  Movee
//
//  Created by user on 4/5/25.
//

import SwiftUI

struct MediasSectionView: View {
    let section: MediasSection
    let medias: [MediaPosterView.DataModel]?
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
                isButtonHidden: viewState != .loaded) {
                AnyView(MediasListView(section: section))
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
                                        MediaDetailsView(media: media)
                                    case .none:
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
    
    init(section: MediasSection, medias: [Media]?, errorMessage: String? = nil, retry: (() -> Void)? = nil, horizontalPadding: CGFloat = 20) {
        self.section = section
        self.medias = medias?.map { .init(media: $0) }
        self.errorMessage = errorMessage
        self.retry = retry
        self.horizontalPadding = horizontalPadding
    }
    
    init(section: MediasSection, items: [MediaPosterView.DataModel]?, errorMessage: String? = nil, retry: (() -> Void)? = nil, horizontalPadding: CGFloat = 20) {
        self.section = section
        self.medias = items
        self.errorMessage = errorMessage
        self.retry = retry
        self.horizontalPadding = horizontalPadding
    }
}
