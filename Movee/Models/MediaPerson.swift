//
//  MediaPerson.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation
import UIKit

struct MediaPerson: Identifiable {
    let id: Int
    let type: PersonType
    let name: String
    let profilePath: String?
    let role: String?
    let department: String?
    let popularity: Double?
    
    let creditID: String?
    let gender: Int?
    
    let castID: Int?
    let order: Int?
    
    // Detailed person info from TMDB
    let birthday: String?
    let deathday: String?
    let biography: String?
    let placeOfBirth: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?
    let alsoKnownAs: [String]?
    let knownFor: [PersonCredit]?
    
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
    
    init(person: Person) {
        self.id = person.id
        self.type = .unknown
        self.name = person.name
        self.profilePath = person.profilePath
        self.role = nil
        self.department = person.department
        self.popularity = nil
        self.creditID = nil
        self.gender = nil
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
    
    init(id: Int, type: PersonType, name: String, profilePath: String? = nil, role: String? = nil, department: String? = nil, popularity: Double? = nil, creditID: String? = nil, gender: Int? = nil, castID: Int? = nil, order: Int? = nil, birthday: String? = nil, deathday: String? = nil, biography: String? = nil, placeOfBirth: String? = nil, adult: Bool? = nil, imdbID: String? = nil, homepage: String? = nil, alsoKnownAs: [String]? = nil, knownFor: [PersonCredit]? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.profilePath = profilePath
        self.role = role
        self.department = department
        self.popularity = popularity
        self.creditID = creditID
        self.gender = gender
        self.castID = castID
        self.order = order
        self.birthday = birthday
        self.deathday = deathday
        self.biography = biography
        self.placeOfBirth = placeOfBirth
        self.adult = adult
        self.imdbID = imdbID
        self.homepage = homepage
        self.alsoKnownAs = alsoKnownAs
        self.knownFor = knownFor
    }
}

extension MediaPerson {
    enum PersonType {
        case cast, crew, unknown
        
        var title: String {
            switch self {
            case .cast:
                return "Cast"
            case .crew:
                return "Crew"
            case .unknown:
                return "Unknown"
            }
        }
    }
    
    var profilePictureURL: URL? {
        guard let profilePath = self.profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w154" + profilePath)
    }
    
    var placeholderImage: UIImage? {
        switch gender {
        case 1:
            UIImage(resource: .imageFemalePersonPlaceholder)
        default:
            UIImage(resource: .imageMalePersonPlaceholder)
        }
    }
    
    var departmentGrouping: String {
        if let department {
            switch type {
            case .cast:
                return "Acting"
            default:
                return department
            }
        } else {
            return type.title
        }
    }
    
    var sorting: Double {
        if let order { return Double (order) }
        else { return 1 / (popularity ?? 1.0) }
    }
}

extension MediaPerson {
    var birthdayDate: Date? {
        guard let bday = birthday else { return nil }
        return MediaFormatterService.shared.parse(dateString: bday)
    }

    var deathDate: Date? {
        guard let dday = deathday else { return nil }
        return MediaFormatterService.shared.parse(dateString: dday)
    }

    var facts: [KeyValueItem<String>] {
        var items = [KeyValueItem<String>]()
        let formatter = MediaFormatterService.shared

        // Known for
        if let dept = department, !dept.isEmpty {
            items.append(.init(key: "Known for", value: dept))
        }

        // Birthday (with age if alive)
        if let birthDate = birthdayDate {
            let birthText = formatter.format(date: birthDate, style: .full)
            if deathDate == nil {
                let age = Calendar.current
                    .dateComponents([.year], from: birthDate, to: Date())
                    .year ?? 0
                items.append(.init(key: "Birthday", value: "\(birthText) (\(age))"))
            } else {
                items.append(.init(key: "Birthday", value: birthText))
            }
        }

        // Deathday (only if deceased, with age at death)
        if let deathDate = deathDate, let birthDate = birthdayDate {
            let deathText = formatter.format(date: deathDate, style: .full)
            let ageAtDeath = Calendar.current
                .dateComponents([.year], from: birthDate, to: deathDate)
                .year ?? 0
            items.append(.init(key: "Deathday", value: "\(deathText) (\(ageAtDeath))"))
        }

        // Place of birth
        if let pob = placeOfBirth, !pob.isEmpty {
            items.append(.init(key: "Place of birth", value: pob))
        }

        // Also known as
        if let akas = alsoKnownAs, !akas.isEmpty {
            items.append(.init(key: "Also known as", value: akas.joined(separator: ", ")))
        }

//        // IMDB ID
//        if let id = imdbID, !id.isEmpty {
//            items.append(.init(key: "IMDB ID", value: id))
//        }
//
//        // Homepage
//        if let home = homepage, !home.isEmpty {
//            items.append(.init(key: "Homepage", value: home))
//        }

        return items
    }
}
