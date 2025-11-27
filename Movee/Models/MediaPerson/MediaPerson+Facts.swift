//
//  MediaPerson+Facts.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

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
        if let birthDate = birthdayDate, let birthText = formatter.format(date: birthDate, style: .full) {
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
        if let deathDate = deathDate, let birthDate = birthdayDate,
           let deathText = formatter.format(date: deathDate, style: .full) {
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
