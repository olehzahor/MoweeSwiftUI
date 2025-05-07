//
//  Media+Facts.swift
//  Movee
//
//  Created by user on 4/11/25.
//

extension Media {
    var facts: [KeyValueItem<String>] {
        switch mediaType {
        case .movie:
            return buildMovieFacts()
        case .tvShow:
            return buildTVShowFacts()
        }
    }
    
    // MARK: - Movie Facts
    private func buildMovieFacts() -> [KeyValueItem<String>] {
        // Safely unwrap the extra info for movies.
        guard case .movie(let movieExtra) = extra else { return [] }
        
        var items = [KeyValueItem<String>]()
        let formatter = MediaFormatterService.shared
                
        items.append(.init(key: "Title", value: title))
        
        if !originalTitle.isEmpty, originalTitle != title {
            items.append(.init(key: "Original title", value: originalTitle))
        }

        // 1. Release Date using the already parsed date.
        if let formattedReleaseDate = formatter.format(date: parsedReleaseDate, style: .full) {
            items.append(.init(key: "Release Date", value: formattedReleaseDate))
        }
        
        // 2. Status
        if let status = movieExtra.status?.rawValue {
            items.append(.init(key: "Status", value: status))
        }

        // 2. Country: Assume productionCountries contains a name property.
        if let countries = movieExtra.productionCountries, !countries.isEmpty {
            let countryNames = countries.compactMap { $0.name }.joined(separator: ", ")
            if !countryNames.isEmpty {
                items.append(.init(key: "Country", value: countryNames))
            }
        }
        
        // 3. Language: Use spokenLanguages if available.
        if let spokenLanguages = movieExtra.spokenLanguages, !spokenLanguages.isEmpty {
            let languages = spokenLanguages.compactMap { $0.englishName }.joined(separator: ", ")
            if !languages.isEmpty {
                items.append(.init(key: "Language", value: languages))
            }
        }
        
        // 4. Rating
        if let ratingString {
            items.append(.init(key: "Rating", value: "\(ratingString) (\(voteCount) votes)"))
        }
        
        // 5. Budget
        if let budget = movieExtra.budget, budget > 0,
           let formattedBudget = formatter.format(currency: budget) {
            items.append(.init(key: "Budget", value: formattedBudget))
        }
        
        // 6. Revenue
        if let revenue = movieExtra.revenue, revenue > 0,
           let formattedRevenue = formatter.format(currency: revenue) {
            let isRevenueGreaterThanBudget = revenue > (movieExtra.budget ?? 0)
            let symbolString = isRevenueGreaterThanBudget ? "↑" : "↓"
            items.append(.init(key: "Revenue", value: symbolString + formattedRevenue))
        }
        
        return items
    }
    
    // MARK: - TV Show Facts
    private func buildTVShowFacts() -> [KeyValueItem<String>] {
        // Safely unwrap the extra info for TV shows.
        guard case .tvShow(let tvShowExtra) = extra else { return [] }
        
        var items = [KeyValueItem<String>]()
        let formatter = MediaFormatterService.shared
        
        items.append(.init(key: "Title", value: title))

        if !originalTitle.isEmpty, originalTitle != title {
            items.append(.init(key: "Original title", value: originalTitle))
        }

        // 1. Network (assuming networks have a name property)
        if let networks = tvShowExtra.networks, !networks.isEmpty {
            let names = networks.compactMap { $0.name }.joined(separator: ", ")
            if !names.isEmpty {
                items.append(.init(key: "Network", value: names))
            }
        }
        
        // 2. Status
        if let status = tvShowExtra.status?.rawValue {
            items.append(.init(key: "Status", value: status))
        }
        
        // 3. Premiered – using the parsed release date.
        if let formattedDate = formatter.format(date: parsedReleaseDate, style: .full) {
            items.append(.init(key: "Premiered", value: formattedDate))
        }
        
        // 4. Last Aired
        if let lastAirDate = tvShowExtra.lastAirDate, !lastAirDate.isEmpty,
           let lastAir = formatter.parse(dateString: lastAirDate),
           let formattedDate = formatter.format(date: lastAir, style: .full) {
            // Use the formatter service to parse the date string.
            items.append(.init(key: "Last Aired", value: formattedDate))
        }
        
        // 5. Next Episode – provide a simplified example.
        if let nextEp = tvShowExtra.nextEpisodeToAir {
            var nextEpDetail = "Episode \(nextEp.episodeNumber) (Season \(nextEp.seasonNumber))"
            if let airDate = nextEp.formattedAirDate, !airDate.isEmpty {
                nextEpDetail += "\n" + airDate
            }
            items.append(.init(key: "Next Episode", value: nextEpDetail))
        }
        
        // 6. Country: using originCountry.
        if let originCountries = tvShowExtra.originCountry, !originCountries.isEmpty {
            items.append(.init(key: "Country", value: originCountries.joined(separator: ", ")))
        }
        
        // 7. Language: assuming languages are available.
        if let spokenLanguages = tvShowExtra.spokenLanguages, !spokenLanguages.isEmpty {
            let languages = spokenLanguages.compactMap { $0.englishName }.joined(separator: ", ")
            if !languages.isEmpty {
                items.append(.init(key: "Language", value: languages))
            }
        }

        // 8. Rating
        if let ratingString {
            items.append(.init(key: "Rating", value: "\(ratingString) (\(voteCount) votes)"))
        }
        
        return items
    }
}

