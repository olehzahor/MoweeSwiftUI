////
////  Item.swift
////  Movee
////
////  Created by user on 5/8/25.
////
//
//
//import SwiftUI
//
//extension AdvancedSearchViewModel {
//    struct Item: Hashable {
//        enum Value: Hashable {
//            case int(Int)
//            case range(Range<Int>)
//            case mediaType(MediaType)
//            case sorting(DiscoverFilters.Sorting)
//        }
//        
//        let title: String
//        let value: Value
//    }
//
//    struct Section: Hashable, Identifiable {
//        enum SelectionRule: Hashable {
//            case exclusive, multiple, multipleWithExclusion, cumulative, range([[Item]])
//        }
//        
//        var items: [Item]
//        var preselectedItems: [Item] = []
//        var title: String
//        var selectionRule: SelectionRule
//        
//        var id: String { title }
//        
//        static var mediaType: Section = {
//            let items: [Item] = [
//                .init(title: "Movie", value: .mediaType(.movie)),
//                .init(title: "TV Show", value: .mediaType(.tvShow))
//            ]
//            var preselectedItems: [Item] = []
//            if let firstItem = items.first {
//                preselectedItems.append(firstItem)
//            }
//            return Section(
//                items: items,
//                preselectedItems: preselectedItems,
//                title: "Media type",
//                selectionRule: .exclusive
//            )
//        }()
//
//        static var movieGenres = Section(
//            items: GenresMapper.shared.movieGenres
//                .map { .init(title: $0.value, value: .int($0.key)) },
//            title: "Genres",
//            selectionRule: .multipleWithExclusion
//        )
//        
//        static var tvGenres = Section(
//            items: GenresMapper.shared.tvGenres
//                .map { .init(title: $0.value, value: .int($0.key)) },
//            title: "Genres",
//            selectionRule: .multipleWithExclusion
//        )
//        
//        static var rating = Section(
//            items: [
//                .init(title: "5+", value: .int(5)),
//                .init(title: "6+", value: .int(6)),
//                .init(title: "7+", value: .int(7)),
//                .init(title: "8+", value: .int(8)),
//                .init(title: "9+", value: .int(9))
//            ],
//            title: "Rating",
//            selectionRule: .cumulative
//        )
//        
//        static var votes = Section(
//            items: [
//                .init(title: "100+", value: .int(100)),
//                .init(title: "500+", value: .int(500)),
//                .init(title: "2000+", value: .int(2000)),
//                .init(title: "5000+", value: .int(5000)),
//                .init(title: "7000+", value: .int(7000)),
//                .init(title: "10000+", value: .int(10000))
//            ],
//            title: "Votes count",
//            selectionRule: .cumulative
//        )
//        
//        static var runtime: Section = {
//            let items: [Item] = [
//                .init(title: "Ultra Short (<1hr)", value: .range(0..<60)),
//                .init(title: "Short (1 to 1.5hrs)", value: .range(60..<90)),
//                .init(title: "Medium (1.5 to 2hrs)", value: .range(90..<120)),
//                .init(title: "Long (>2hrs)", value: .range(120..<Int.max))
//            ]
//            return Section(
//                items: items,
//                title: "Runtime",
//                selectionRule: .range([items])
//            )
//        }()
//        
//        static var releaseDate: Section = {
//            let currentYear = Calendar.current.component(.year, from: Date())
//            let recentYears: [Item] = (0..<3).map { offset in
//                let year = currentYear - offset
//                return .init(title: "\(year)", value: .int(year))
//            }
//            let otherYears: [Item] = [
//                .init(title: "2020s", value: .range(2020..<2030)),
//                .init(title: "2010s", value: .range(2010..<2020)),
//                .init(title: "2000s", value: .range(2000..<2010)),
//                .init(title: "1990s", value: .range(1990..<2000)),
//                .init(title: "1980s", value: .range(1980..<1990)),
//                .init(title: "1970s", value: .range(1970..<1980)),
//                .init(title: "1960s", value: .range(1960..<1970)),
//                .init(title: "1950s", value: .range(1950..<1960)),
//                .init(title: "1940s", value: .range(1940..<1950)),
//                .init(title: "1930s", value: .range(1930..<1940))
//            ]
//            let allItems = recentYears + otherYears
//            return Section(
//                items: allItems,
//                title: "Release date",
//                selectionRule: .range([recentYears, otherYears])
//            )
//        }()
//        
//        static var sorting: Section = {
//            let items: [Item] = [
//                .init(title: "Trending",           value: .sorting(.popularityDesc)),
//                .init(title: "Newest Releases",    value: .sorting(.releaseDateDesc)),
//                .init(title: "Top Rated",          value: .sorting(.voteAverageDesc)),
//                .init(title: "Most Voted",         value: .sorting(.voteCountDesc)),
//                .init(title: "Box Office Hits",    value: .sorting(.revenueDesc))
//            ]
//            return Section(
//                items: items,
//                preselectedItems: [items.first!],
//                title: "Sort by",
//                selectionRule: .exclusive
//            )
//        }()
//    }
//}
//
//extension AdvancedSearchViewModel.Item.Value {
//    var intValue: Int? {
//        if case let .int(id) = self { return id }
//        return nil
//    }
//    
//    var rangeValue: Range<Int>? {
//        if case let .range(r) = self { return r }
//        return nil
//    }
//    
//    var mediaTypeValue: MediaType? {
//        if case let .mediaType(m) = self { return m }
//        return nil
//    }
//    
//    var sortingValue: DiscoverFilters.Sorting? {
//        if case let .sorting(s) = self { return s }
//        return nil
//    }
//}
