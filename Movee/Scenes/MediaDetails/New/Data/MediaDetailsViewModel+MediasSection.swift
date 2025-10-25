//
//  MediasSection.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

extension NewMediaDetailsViewModel {
    struct MediasSection<T> {
        var name: String
        var fullName: String?
        var placeholder: NewMediasSection.Placeholder?
        var dataProvider: (any MediasListDataProvider)?
        
        var items = [T]()
        
        var section: NewMediasSection { .init(
            title: name,
            fullTitle: fullName,
            placeholder: placeholder,
            dataProvider: dataProvider)
        }
    }
}

extension NewMediaDetailsViewModel.MediasSection where T == Media {
    mutating func update(with collection: MediasCollection) {
        self.name = collection.name
        self.items = collection.medias
    }
}
