//
//  MediaPerson+CastMember.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

extension MediaPerson {
    init(castMember: CastMember) {
        self.id = castMember.id
        self.type = .cast
        self.name = castMember.name
        self.profilePath = castMember.profilePath
        self.role = castMember.character
        self.department = castMember.department
        self.popularity = castMember.popularity
        self.creditID = castMember.creditID
        self.gender = castMember.gender
        self.castID = castMember.castID
        self.order = castMember.order
        self.birthday = nil
        self.deathday = nil
        self.biography = nil
        self.placeOfBirth = nil
        self.adult = nil
        self.imdbID = nil
        self.homepage = nil
        self.alsoKnownAs = nil
        self.knownFor = nil
    }
}
