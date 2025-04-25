//
//  MediaDetailsView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine

// TODO: state driven views
struct MediaReviewView: View {
    var review: Review
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack(alignment: .leading) {
                Text(.init(review.content))
                    .font(.system(.callout))
                    .multilineTextAlignment(.leading)
                Spacer()
                Divider().padding(.bottom, 8)
                HStack {
                    Text("⭐️ 7.0")
                    Spacer()
                    Text("Reviewed by \(review.authorString) two years ago ")
                }.font(.caption)
            }.padding()
        }
        .clipShape(.rect(cornerRadius: 8))
        .tint(.secondary)
    }
}

struct MediaReviewsCarouselView: View {
    var reviews: [Review]
    var horizontalPadding: CGFloat = 20
    @State private var selectedReview: Review? = nil
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(reviews) { review in
                    MediaReviewView(review: review)
                        .containerRelativeFrame(.horizontal)
                        .onTapGesture {
                            selectedReview = review
                        }
                }
            }
            .frame(height: 250)
            .scrollTargetLayout()
        }
        .contentMargins(horizontalPadding, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .padding(.horizontal, -horizontalPadding)
        .sheet(item: $selectedReview) { review in
            ReviewView(mediaTitle: "Hello there", review: review)
        }
    }
}

struct MediaFactRowView: View {
    var fact: KeyValueItem<String>
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(fact.key).font(.headline)
                Spacer()
                Text(fact.value).font(.headline).foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }.padding(.vertical, 4)
            Divider()
        }
    }
}


struct MediaFactsView: View {
    var facts: [KeyValueItem<String>]
    
    var body: some View {
        VStack {
            ForEach(facts) { fact in
                MediaFactRowView(fact: fact)
            }
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

struct MediaDetailsView: View {
    @StateObject var viewModel: MediaDetailsViewModel
    
    @State private var isScrolledDown: Bool = false
    @State private var headerSize: CGSize = .zero
    
    var body: some View {
        if let media = viewModel.media {
            ScrollView {
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
                            Group {
                                if let tagline = media.tagline, !tagline.isEmpty {
                                    Text(tagline)
                                } else if viewModel.isInWatchlist == nil {
                                    Text("#############################")
                                        .redacted(reason: .placeholder)
                                        .shimmering()
                                }
                            }.textStyle(.tagline)
                            Text(media.overview)
                                .textStyle(.mediumText)
                        }
                        HStack {
                            Text("Cast and Crew")
                                .textStyle(.sectionTitle)
                            Spacer()
                            NavigationLink {
                                MediaPersonsListView(persons: viewModel.credits)
                            } label: {
                                Text("See all")
                            }
                        }
                        PersonsCarouselView(persons: viewModel.credits)
                            .onFirstAppear {
                                viewModel.fetchCredits()
                            }
                        if let relatedSection = viewModel.relatedSection {
                            MediasSectionView(
                                section: relatedSection,
                                medias: viewModel.related,
                                errorMessage: nil,
                                isLoading: viewModel.related.isEmpty,
                                retry: { }
                            ).onFirstAppear {
                                viewModel.fetchRelated()
                            }
                        }
                        Text("Facts")
                            .textStyle(.sectionTitle)
                        MediaFactsView(facts: media.facts)
                        
                        if !viewModel.reviews.isEmpty {
                            Text("Reviews")
                                .textStyle(.sectionTitle)
                            MediaReviewsCarouselView(reviews: viewModel.reviews).onFirstAppear {
                                viewModel.fetchReviews()
                            }
                        }
                        
                        //MediaTrailerView()
                    }
                    .padding(.horizontal, 20)
                }
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
