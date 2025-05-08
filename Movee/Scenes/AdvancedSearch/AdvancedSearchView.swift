//
//  AdvancedSearchView.swift
//  Movee
//
//  Created by user on 5/7/25.
//

import SwiftUI

final class AdvancedSearchViewModel: ObservableObject {
    @Published private(set) var sections: [Section] = [
        .mediaType, .movieGenres, .rating, .votes, .runtime, .releaseDate, .sorting
    ]
        
    @Published private var selectedItems: [Section: [Item]] = [:]
    @Published private var excludedItems: [Section: [Item]] = [:]
    
    private var selectedMediaType: MediaType {
        switch getSelectedItems(in: .mediaType).first?.value {
        case .mediaType(let mediaType):
            return mediaType
        default:
            return .movie
        }
    }
    
    var resultsSection: MediasSection {
        return MediasSection(title: "Search results") { [unowned self] page in
            var filters = getFilters()
            
            return switch selectedMediaType {
            case .movie:
                TMDBAPIClient.shared.discoverMovies(filters: filters, page: page)
                    .map { $0.map { Media(movie: $0) } }
                    .eraseToAnyPublisher()
            case .tvShow:
                TMDBAPIClient.shared.discoverTVShows(filters: filters, page: page)
                    .map { $0.map { Media(tvShow: $0) } }
                    .eraseToAnyPublisher()
            }
        }
    }

    private func getFilters() -> DiscoverFilters {
        var filters = DiscoverFilters()
        
        // Media type (default movie endpoint, tv handled in resultsSection)
        let mediaType = selectedMediaType
        
        // Genres inclusion/exclusion
        let genreSection = mediaType == .movie ? Section.movieGenres : Section.tvGenres
        let includedGenreIDs = selectedItems[genreSection]?.compactMap { $0.value.intValue } ?? []
        let excludedGenreIDs = excludedItems[genreSection]?.compactMap { $0.value.intValue } ?? []
        if !includedGenreIDs.isEmpty {
            filters.withGenres = ListFilter(values: includedGenreIDs, combination: .or)
        }
        if !excludedGenreIDs.isEmpty {
            filters.withoutGenres = ListFilter(values: excludedGenreIDs, combination: .or)
        }

        // Rating (cumulative)
        if let ratings = selectedItems[.rating], !ratings.isEmpty,
           let minRating = ratings.compactMap({ $0.value.intValue }).min() {
            filters.voteAverageGTE = Double(minRating)
        }

        // Votes count (cumulative)
        if let votes = selectedItems[.votes], !votes.isEmpty,
           let minVotes = votes.compactMap({ $0.value.intValue }).min() {
            filters.voteCountGTE = minVotes
        }

        // Runtime ranges
        if let runtimes = selectedItems[.runtime], !runtimes.isEmpty {
            let ranges = runtimes.compactMap { $0.value.rangeValue }
            if let lower = ranges.map(\.lowerBound).min() {
                filters.withRuntimeGTE = lower
            }
            if let upper = ranges.map(\.upperBound).max(), upper != Int.max {
                filters.withRuntimeLTE = upper
            }
        }

        // Release date (support single years and decades)
        if let dates = selectedItems[.releaseDate], !dates.isEmpty {
            let singleYearRanges = dates.compactMap {
                $0.value.intValue.map { year in year..<year+1 }
            }
            let decadeRanges = dates.compactMap { $0.value.rangeValue }
            let allRanges = singleYearRanges + decadeRanges
            if let start = allRanges.map(\.lowerBound).min() {
                filters.primaryReleaseDateGTE = "\(start)-01-01"
            }
            if let end = allRanges.map({ $0.upperBound - 1 }).max() {
                filters.primaryReleaseDateLTE = "\(end)-12-31"
            }
        }

        if let sortingItem = selectedItems[.sorting]?.first?.value,
           case .sorting(let sortOption) = sortingItem {
            filters.sortBy = sortOption
        }
        
        return filters
    }
    
    private func getSelectedItems(in section: Section) -> [Item] {
        selectedItems[section] ?? []
    }
    
    private func configureListAfterSelected(_ item: Item, in section: Section) {
        switch selectedMediaType {
        case .movie:
            sections[1] = .movieGenres
        case .tvShow:
            sections[1] = .tvGenres
        }
    }
    
    func selectItem(_ item: Item, in section: Section) {
        switch section.selectionRule {
        case .exclusive:
            // Only one item can be selected at a time; tapping it again clears selection
            if let current = selectedItems[section], current.first == item {
                selectedItems[section] = []
            } else {
                selectedItems[section] = [item]
            }
            // Clear any exclusions as well
            excludedItems[section] = []
        case .multiple:
            var current = selectedItems[section] ?? []
            if let index = current.firstIndex(of: item) {
                current.remove(at: index)
            } else {
                current.append(item)
            }
            selectedItems[section] = current
            
        case .multipleWithExclusion:
            // 1) Get or initialize
            var current  = selectedItems[section] ?? []
            var excluded = excludedItems[section] ?? []

            // 2) First tap → select; second tap → exclude; third tap → remove completely
            if current.contains(item) {
                current.removeAll { $0 == item }
                excluded.append(item)
            } else if excluded.contains(item) {
                excluded.removeAll { $0 == item }
            } else {
                current.append(item)
            }

            // 3) Save back
            selectedItems[section] = current
            excludedItems[section] = excluded
            
        case .cumulative:
            let current = selectedItems[section] ?? []
            // If tapping the first selected item, clear all
            if let firstSelected = current.first, firstSelected == item {
                selectedItems[section] = []
            } else {
                // Otherwise select from tapped item through end
                guard let startIndex = section.items.firstIndex(of: item) else { return }
                let newRange = section.items[startIndex...]
                selectedItems[section] = Array(newRange)
            }

        case .range(let ranges):
            // Find which subgroup contains the tapped item
            guard let rangeGroup = ranges.first(where: { $0.contains(item) }) else {
                // If item isn’t in any subgroup, reset to that single item
                selectedItems[section] = [item]
                return
            }
            // Only work within that subgroup
            let current = selectedItems[section]?.filter { rangeGroup.contains($0) } ?? []

            if current.contains(item) {
                // Clear selection within this subgroup
                selectedItems[section] = []
            } else {
                // Build contiguous range inside subgroup
                if let newIdx = rangeGroup.firstIndex(of: item),
                   let minIdx = current.compactMap({ rangeGroup.firstIndex(of: $0) }).min(),
                   let maxIdx = current.compactMap({ rangeGroup.firstIndex(of: $0) }).max() {
                    if newIdx == minIdx - 1 {
                        selectedItems[section] = Array(rangeGroup[newIdx...maxIdx])
                    } else if newIdx == maxIdx + 1 {
                        selectedItems[section] = Array(rangeGroup[minIdx...newIdx])
                    } else {
                        selectedItems[section] = [item]
                    }
                } else {
                    // Start new range
                    selectedItems[section] = [item]
                }
            }
        }
        configureListAfterSelected(item, in: section)
    }
    
    func isSelected(_ item: Item, in section: Section) -> Bool {
        selectedItems[section]?.contains(item) ?? false
    }
    
    func isExcluded(_ item: Item, in section: Section) -> Bool {
        excludedItems[section]?.contains(item) ?? false
    }
    
    private func handleInitialSelections() {
        for section in sections {
            for item in section.preselectedItems {
                selectItem(item, in: section)
            }
        }
    }
    
    init() {
        handleInitialSelections()
    }
}

struct AdvancedSearchView: View {
    @StateObject var viewModel = AdvancedSearchViewModel()
    
    private let columns = [
      GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    @ViewBuilder
    private func createButtonView(_ item: AdvancedSearchViewModel.Item,
                                  section: AdvancedSearchViewModel.Section) -> some View {
        let isSelected = viewModel.isSelected(item, in: section)
        let isExcluded = viewModel.isExcluded(item, in: section)
        
        var title = isExcluded ? "-\(item.title)" : item.title
        
        let button = Button(title) {
            viewModel.selectItem(item, in: section)
        }
        
        if isSelected {
            button.buttonStyle(.borderedProminent)
        }
        else if isExcluded {
            button
                .buttonStyle(.borderedProminent)
                .tint(.red)
        } else {
            button.buttonStyle(.bordered)
        }
    }
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.sections) { section in
                        Text(section.title)
                            .textStyle(.sectionTitle)
                        OverflowLayout(spacing: 8) {
                            ForEach(section.items, id: \.self) { item in
                                createButtonView(item, section: section)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    }
                    NavigationLink(destination: MediasListView(section: viewModel.resultsSection)) {
                        Text("Search")
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.bottom)
                }.padding(.horizontal)
            }
            .navigationTitle("Advanced search")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    AdvancedSearchView()
}
