//
//  AppRoute.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

enum AppRoute: Route {
    case mediasList(MediasSection)
    case mediaDetails(Media)
    
    case personsList([MediaPerson])
    case personDetails(MediaPerson)

    case seasonDetails(Int, Season)
    case review(String, Review)
    case collection(String, [MediasList])
    
    case advancedSearch
    case searchHistory

    var id: Self { self }

    @ViewBuilder @MainActor
    var view: some View {
        switch self {
        case .mediasList(let section):
            MediasListView(section: section)
        case .mediaDetails(let media):
            MediaDetailsView(media: media)
        case .personsList(let persons):
            MediaPersonsListView(persons: persons)
        case .personDetails(let person):
            PersonDetailsView(person: person)
        case .seasonDetails(let tvShowID, let season):
            SeasonDetailsView(tvShowID: tvShowID, season: season)
        case .review(let title, let review):
            ReviewView(mediaTitle: title, review: review)
        case .collection(let title, let lists):
            CollectionView(title: title, lists: lists)
        case .advancedSearch:
            AdvancedSearchView()
        case .searchHistory:
            MediasListView(.searchHistory())
        }
    }
}
