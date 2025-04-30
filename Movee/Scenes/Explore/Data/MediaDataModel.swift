//
//  NavigationAction.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import Foundation

extension MediaPosterView {
    enum NavigationAction {
        case media(Media)
    }

    protocol MediaDataModel {
        var title: String { get }
        var subtitle: String? { get }
        var posterURL: URL? { get }
        var rating: Double? { get }
        var navigation: NavigationAction { get }
    }
}

extension Media: MediaPosterView.MediaDataModel {
    var subtitle: String? {
        nil
    }
    
    var rating: Double? {
        voteAverage
    }
    
    var navigation: MediaPosterView.NavigationAction {
        .media(self)
    }
}
