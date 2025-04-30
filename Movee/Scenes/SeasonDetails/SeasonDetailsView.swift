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
    
    private var cancellables = Set<AnyCancellable>()

    func fetchDetails() {
        TMDBAPIClient.shared.fetchTVShowSeason(tvShowID: tvShowID, seasonNumber: season.seasonNumber).sink { completion in
            
        } receiveValue: { season in
            self.season = season
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
            VStack(alignment: .leading, spacing: 2) {
                Text("\(episode.episodeNumber). \(episode.name)")
                    .multilineTextAlignment(.leading)
                    .lineLimit(titleLineLimit)
                    .textStyle(.mediumTitle)
                if let formattedAirDate = episode.formattedAirDate {
                    Text(formattedAirDate)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                }
                FoldableTextView(text: episode.overview, lineLimit: nil) {
                    isExpanded = true
                }
                .textStyle(.mediumText)
                .lineSpacing(-3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let stillURL = episode.stillURL {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImageView(url: stillURL, width: 110, height: 97, cornerRadius: 8)
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
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.season.overview).textStyle(.mediumText)
                Divider()
                ForEach(viewModel.season.episodes ?? [], id: \.id) { episode in
                    EpisodeDetailsView(episode: episode)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.season.name)
        .onFirstAppear {
            viewModel.fetchDetails()
        }
    }
    
    init(tvShowID: Int, season: Season) {
        _viewModel = .init(wrappedValue: .init(
            tvShowID: tvShowID,
            season: season)
        )
    }
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
        overview: "After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope.",
        posterPath: "/pMfG5XIlmvCL9bQQiJKdTvmF2FW.jpg",
        seasonNumber: 1,
        voteAverage: 7.8
    )
}

#Preview {
    SeasonDetailsView(tvShowID: 100088, season: .mock)
}
