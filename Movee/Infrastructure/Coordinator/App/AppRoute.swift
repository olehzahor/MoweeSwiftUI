//
//  AppRoute.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

enum AppRoute: Route {
    case mediaDetails(Media)
    case seasonDetails(Int, Season)
    case review(String, Review)

    var id: Self { self }

    @ViewBuilder
    var view: some View {
        switch self {
        case .mediaDetails(let media):
            MediaDetailsView(media: media)
        case .seasonDetails(let tvShowID, let season):
            SeasonDetailsView(tvShowID: tvShowID, season: season)
        case .review(let title, let review):
            ReviewView(mediaTitle: title, review: review)
        }
    }
}
