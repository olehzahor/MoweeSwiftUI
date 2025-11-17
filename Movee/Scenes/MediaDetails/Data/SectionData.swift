//
//  SectionData.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

struct SectionData<T> {
    var name: String
    var fullName: String?
    var dataProvider: (any MediasListDataProvider)?

    var items = [T]()

    var section: MediasSection { .init(
        title: name,
        fullTitle: fullName,
        dataProvider: dataProvider)
    }
}

extension SectionData where T == Media {
    mutating func update(with collection: MediasCollection) {
        self.name = collection.name
        self.items = collection.medias
    }
}
