//
//  MediaPerson+CrewMember.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

extension MediaPerson {
    init(crewMember: CrewMember) {
        self.id = crewMember.id
        self.type = .crew
        self.name = crewMember.name
        self.profilePath = crewMember.profilePath
        self.role = crewMember.job ?? crewMember.department
        self.department = crewMember.department
        self.popularity = crewMember.popularity
        self.creditID = crewMember.creditID
        self.gender = crewMember.gender
        self.castID = nil
        self.order = nil
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
