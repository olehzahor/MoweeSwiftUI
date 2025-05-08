//
//  DiscoverFilters.swift
//  Movee
//
//  Created by user on 5/7/25.
//

import Foundation

enum Combination {
    case and, or
    
    /// TMDB expects comma for AND, pipe for OR
    var separator: String {
        switch self {
        case .and: return ","
        case .or:  return "|"
        }
    }
}

/// Wraps a list of values with an AND/OR combination rule.
struct ListFilter<Value> {
    var values: [Value]
    var combination: Combination = .and
    
    func parameterValue() -> String {
        values.map { "\($0)" }.joined(separator: combination.separator)
    }
}

/// Available sort options for Discover endpoints.
extension DiscoverFilters {
    enum Sorting: String, Codable, CaseIterable {
        case popularityAsc          = "popularity.asc"
        case popularityDesc         = "popularity.desc"
        case releaseDateAsc         = "release_date.asc"
        case releaseDateDesc        = "release_date.desc"
        case revenueAsc             = "revenue.asc"
        case revenueDesc            = "revenue.desc"
        case primaryReleaseDateAsc  = "primary_release_date.asc"
        case primaryReleaseDateDesc = "primary_release_date.desc"
        case originalTitleAsc       = "original_title.asc"
        case originalTitleDesc      = "original_title.desc"
        case voteAverageAsc         = "vote_average.asc"
        case voteAverageDesc        = "vote_average.desc"
        case voteCountAsc           = "vote_count.asc"
        case voteCountDesc          = "vote_count.desc"
    }
}

struct DiscoverFilters {
    var includeAdult: Bool? = nil
    var includeVideo: Bool? = nil
    var certificationCountry: String? = nil
    var certificationGTE: String? = nil
    var certificationLTE: String? = nil
    var withGenres: ListFilter<Int>? = nil
    var withoutGenres: ListFilter<Int>? = nil
    var withKeywords: ListFilter<Int>? = nil
    var withoutKeywords: ListFilter<Int>? = nil
    var withCompanies: ListFilter<Int>? = nil
    var withoutCompanies: ListFilter<Int>? = nil
    var withPeople: ListFilter<Int>? = nil
    var withNetworks: ListFilter<Int>? = nil
    var withOriginalLanguage: String? = nil
    var region: String? = nil
    var sortBy: Sorting? = nil
    var voteCountGTE: Int? = nil
    var voteCountLTE: Int? = nil
    var voteAverageGTE: Double? = nil
    var voteAverageLTE: Double? = nil
    var withRuntimeGTE: Int? = nil
    var withRuntimeLTE: Int? = nil
    var primaryReleaseYear: Int? = nil
    var primaryReleaseDateGTE: String? = nil
    var primaryReleaseDateLTE: String? = nil
    var releaseDateGTE: String? = nil
    var releaseDateLTE: String? = nil
    var includeNullFirstAirDates: Bool? = nil
    var firstAirDateGTE: String? = nil
    var firstAirDateLTE: String? = nil
    var firstAirDateYear: Int? = nil
    var withWatchProviders: ListFilter<Int>? = nil
    var watchRegion: String? = nil
    var withWatchMonetizationTypes: ListFilter<String>? = nil

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let includeAdult = includeAdult { params["include_adult"] = includeAdult }
        if let includeVideo = includeVideo { params["include_video"] = includeVideo }
        if let certCountry = certificationCountry { params["certification_country"] = certCountry }
        if let gte = certificationGTE { params["certification.gte"] = gte }
        if let lte = certificationLTE { params["certification.lte"] = lte }
        if let filter = withGenres, !filter.values.isEmpty { params["with_genres"] = filter.parameterValue() }
        if let filter = withoutGenres, !filter.values.isEmpty { params["without_genres"] = filter.parameterValue() }
        if let filter = withKeywords, !filter.values.isEmpty { params["with_keywords"] = filter.parameterValue() }
        if let filter = withoutKeywords, !filter.values.isEmpty { params["without_keywords"] = filter.parameterValue() }
        if let filter = withCompanies, !filter.values.isEmpty { params["with_companies"] = filter.parameterValue() }
        if let filter = withoutCompanies, !filter.values.isEmpty { params["without_companies"] = filter.parameterValue() }
        if let filter = withPeople, !filter.values.isEmpty { params["with_people"] = filter.parameterValue() }
        if let filter = withNetworks, !filter.values.isEmpty { params["with_networks"] = filter.parameterValue() }
        if let lang = withOriginalLanguage { params["with_original_language"] = lang }
        if let region = region { params["region"] = region }
        if let sort = sortBy { params["sort_by"] = sort.rawValue }
        if let vGTE = voteCountGTE { params["vote_count.gte"] = vGTE }
        if let vLTE = voteCountLTE { params["vote_count.lte"] = vLTE }
        if let avgGTE = voteAverageGTE { params["vote_average.gte"] = avgGTE }
        if let avgLTE = voteAverageLTE { params["vote_average.lte"] = avgLTE }
        if let rGTE = withRuntimeGTE { params["with_runtime.gte"] = rGTE }
        if let rLTE = withRuntimeLTE { params["with_runtime.lte"] = rLTE }
        if let pry = primaryReleaseYear { params["primary_release_year"] = pry }
        if let prGTE = primaryReleaseDateGTE { params["primary_release_date.gte"] = prGTE }
        if let prLTE = primaryReleaseDateLTE { params["primary_release_date.lte"] = prLTE }
        if let rdGTE = releaseDateGTE { params["release_date.gte"] = rdGTE }
        if let rdLTE = releaseDateLTE { params["release_date.lte"] = rdLTE }
        if let includeNull = includeNullFirstAirDates { params["include_null_first_air_dates"] = includeNull }
        if let faGTE = firstAirDateGTE { params["first_air_date.gte"] = faGTE }
        if let faLTE = firstAirDateLTE { params["first_air_date.lte"] = faLTE }
        if let faYear = firstAirDateYear { params["first_air_date_year"] = faYear }
        if let filter = withWatchProviders, !filter.values.isEmpty { params["with_watch_providers"] = filter.parameterValue() }
        if let watchReg = watchRegion { params["watch_region"] = watchReg }
        if let filter = withWatchMonetizationTypes, !filter.values.isEmpty { params["with_watch_monetization_types"] = filter.parameterValue() }
        return params
    }
}
