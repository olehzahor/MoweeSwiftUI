//
//  PersonDetailsRepositoryParser.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//


import SwiftUI
import Combine

protocol PersonDetailsRepositoryParserProtocol {
    func parse(_ response: PersonCombinedCreditsResponse) -> [Media]
}

struct PersonDetailsRepositoryParser: PersonDetailsRepositoryParserProtocol {
    func parse(_ response: PersonCombinedCreditsResponse) -> [Media] {
        let combined = response.crew + response.cast
        var unique = [Media]()
        for credit in combined {
            let media = credit.media
            if let idx = unique.firstIndex(where: { $0.id == media.id }) {
                var existing = unique[idx]
                let existingText = existing.subtitle ?? ""
                let newText = media.subtitle ?? ""
                if !existingText.isEmpty && !newText.isEmpty {
                    existing.subtitle = existingText + " • " + newText
                } else {
                    existing.subtitle = existingText.isEmpty ? newText : existingText
                }
                unique[idx] = existing
            } else {
                unique.append(media)
            }
        }
        return unique.sorted(by: { $0.voteCount >= $1.voteCount })
    }
}
