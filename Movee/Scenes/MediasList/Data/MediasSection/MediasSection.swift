//
//  MediasSection.swift
//  Movee
//
//  Created by Oleh on 29.10.2025.
//

import Factory

struct MediasSection {
    let title: String
    let fullTitle: String?
    let dataProvider: MediasListDataProvider?
    
    init(title: String, fullTitle: String? = nil, dataProvider: MediasListDataProvider? = nil) {
        self.title = title
        self.fullTitle = fullTitle
        self.dataProvider = dataProvider
    }
}

extension MediasSection: Hashable, Identifiable {
    var id: String { title }

    static func == (lhs: MediasSection, rhs: MediasSection) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
