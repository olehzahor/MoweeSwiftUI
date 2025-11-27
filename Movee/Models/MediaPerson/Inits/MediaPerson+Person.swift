//
//  MediaPerson+Person.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

extension MediaPerson {
    init(person: Person) {
        self.id = person.id
        self.type = .unknown
        self.name = person.name
        self.profilePath = person.profilePath
        self.role = nil
        self.department = person.department
        self.popularity = nil
        self.creditID = nil
        self.gender = person.gender
        self.castID = nil
        self.order = nil
        self.birthday = person.birthday
        self.deathday = person.deathday
        self.biography = person.biography
        self.placeOfBirth = person.placeOfBirth
        self.adult = person.adult
        self.imdbID = person.imdbID
        self.homepage = person.homepage
        self.alsoKnownAs = person.alsoKnownAs
        self.knownFor = person.knownFor
    }
}
