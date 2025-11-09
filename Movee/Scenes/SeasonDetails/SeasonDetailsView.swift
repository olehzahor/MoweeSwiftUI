//
//  SeasonDetailsView.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import SwiftUI
import Combine

class SeasonDetailsViewModel: ObservableObject {
    private var tvShowID: Int
    @Published var season: Season
    
    enum Section { case episodes }
    @Published var state = ViewLoadingState<Section>()
    
    private var cancellables = Set<AnyCancellable>()

    func fetchDetails() {
        state.setLoading(.episodes)
        TMDBAPIClient.shared.fetchTVShowSeason(tvShowID: tvShowID, seasonNumber: season.seasonNumber).sink { [unowned self] completion in
            if case .failure(let error) = completion {
                state.setError(.episodes, error)
            }
        } receiveValue: { [unowned self] season in
            self.season = season
            state.setLoaded(.episodes, isEmpty: season.episodes?.isEmpty ?? true)
        }.store(in: &cancellables)
    }
    
    init(tvShowID: Int, season: Season) {
        self.tvShowID = tvShowID
        self.season = season
    }
}

struct EpisodeDetailsView: View {
    var episode: Episode
    
    @State var isExpanded: Bool = false
    @State private var posterSize: CGSize = .zero
    
    private var maxHeight: CGFloat? {
        isExpanded ? nil : (posterSize.height == .zero ? nil : posterSize.height)
    }
    
    private var titleLineLimit: Int? {
        isExpanded ? nil : 1
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(episode.episodeNumber). \(episode.name)")
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumTitle)
                if let detailsString = episode.detailsString {
                    Text(detailsString)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                        .textStyle(.smallText)
                        .fontWeight(.semibold)
                }
                FoldableTextView(text: episode.overview, lineLimit: nil) {
                    isExpanded = true
                }
                .hidden(episode.overview.isEmpty)
                .textStyle(.smallText)
                .lineSpacing(-3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let stillURL = episode.stillURL {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImageView(url: stillURL, width: 110, height: 93, cornerRadius: 8, placeholder: .imageMoviePlaceholder)
                        .saveSize(in: $posterSize)
                    if let rating = episode.voteAverage, rating > 0 {
                        MediaRatingView(rating: rating)
                            .padding(.bottom, 4)
                            .padding(.trailing, 4)
                    }
                }
            }
        }.frame(maxHeight: maxHeight)
    }
}

struct SeasonDetailsView: View {
    @StateObject var viewModel: SeasonDetailsViewModel

    var body: some View {
        List {
            Section {
                if !viewModel.season.overview.isEmpty {
                    FoldableTextView(text: viewModel.season.overview, lineLimit: 10)
                        .textStyle(.mediumText)
                        .listSeparatorTrailingAligned()
                        .listRowSeparator(.hidden, edges: .top)
                }
                
                Group {
                    if viewModel.state.isLoading(.episodes) {
                        ForEach(0..<10, id: \.self) { _ in
                            EpisodeDetailsView(episode: .placeholder)
                                .redacted(reason: .placeholder)
                                .shimmering()
                        }
                    }
                    ForEach(viewModel.season.episodes ?? [], id: \.id) { episode in
                        EpisodeDetailsView(episode: episode)
                    }
                }.listSeparatorTrailingAligned()
            }.listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle(viewModel.season.name)
        .onFirstAppear {
            viewModel.fetchDetails()
        }
    }

    init(tvShowID: Int, season: Season) {
        _viewModel = StateObject(
            wrappedValue: SeasonDetailsViewModel(tvShowID: tvShowID, season: season)
        )
    }
}

private extension Episode {
    static let placeholder = Episode(
        id: -1,
        episodeNumber: -1,
        name: .placeholder(.short),
        overview: .placeholder(.custom(100)),
        seasonNumber: 1,
        stillPath: "")
}

private extension Season {
    static let mock = Season(
        id: 100088,
        airDate: "2023-01-15",
        episodes: [
            Episode(
                id: 2181581,
                airDate: "2023-01-15",
                episodeNumber: 1,
                episodeType: "standard",
                name: "When You're Lost in the Darkness",
                overview: "2003. As a parasitic fungal outbreak begins to ravage the country and the world, Joel Miller attempts to escape the escalating chaos with his daughter and brother. Twenty years later, a now hardened Joel and his partner Tess fight to survive under a totalitarian regime, while the insurgent Fireflies harbor a teenage girl with a unique gift.",
                productionCode: "",
                runtime: 81,
                seasonNumber: 1,
                showID: 100088,
                stillPath: "/3VeY1k8wFyhcrMyQ8jpGegh9beU.jpg",
                voteAverage: 8.328,
                voteCount: 235
            ),
            Episode(
                id: 2181582,
                airDate: "2023-01-22",
                episodeNumber: 2,
                episodeType: "standard",
                name: "Episode 2 Title",
                overview: "Joel and Ellie continue their journey, facing new threats and forging a deeper bond.",
                productionCode: "",
                runtime: 55,
                seasonNumber: 1,
                showID: 100088,
                stillPath: nil,
                voteAverage: 7.5,
                voteCount: 150
            )
        ],
        episodeCount: 9,
        name: "Season 1",
        overview: "After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope. After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope.",
        posterPath: "/pMfG5XIlmvCL9bQQiJKdTvmF2FW.jpg",
        seasonNumber: 1,
        voteAverage: 7.8
    )
}

#Preview {
    SeasonDetailsView(tvShowID: 100088, season: .mock)
}
