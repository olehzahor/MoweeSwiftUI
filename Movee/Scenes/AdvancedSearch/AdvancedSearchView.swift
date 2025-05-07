//
//  AdvancedSearchView.swift
//  Movee
//
//  Created by user on 5/7/25.
//

import SwiftUI

extension AdvancedSearchViewModel {
    struct Item: Hashable {
        let title: String
        let value: Int
    }

    struct Section: Hashable, Identifiable {
        enum SelectionRule: Hashable {
            case multiple, cumulative, range([[Item]])
        }
        
        var items: [Item]
        var title: String
        var selectionRule: SelectionRule
        
        var id: String { title }
        
        static var genres = Section(
            items: GenresMapper.shared.movieGenres
                .map { .init(title: $0.value, value: $0.key) },
            title: "Genres",
            selectionRule: .multiple
        )
        
        static var rating = Section(
            items: [
                .init(title: "9+", value: 9),
                .init(title: "8+", value: 8),
                .init(title: "7+", value: 7),
                .init(title: "6+", value: 6),
                .init(title: "5+", value: 5)
            ],
            title: "Rating",
            selectionRule: .cumulative
        )
        
        static var votes = Section(
            items: [
                .init(title: "100+", value: 100),
                .init(title: "500+", value: 500),
                .init(title: "2000+", value: 2000),
                .init(title: "5000+", value: 5000),
                .init(title: "7000+", value: 7000),
                .init(title: "10000+", value: 10000)
            ],
            title: "Votes count",
            selectionRule: .cumulative
        )
        
        static var runtime: Section = {
            let items: [Item] = [
                .init(title: "Ultra Short (<1hr)", value: 60),
                .init(title: "Short (1 to 1.5hrs)", value: 90),
                .init(title: "Medium (1.5 to 2hrs)", value: 120),
                .init(title: "Long (>2hrs)", value: 150)
            ]
            return Section(
                items: items,
                title: "Runtime",
                selectionRule: .range([items])
            )
        }()
        
        static var releaseDate: Section = {
            // Recent individual years
            let recentYears: [Item] = [
                .init(title: "2025", value: 2025),
                .init(title: "2024", value: 2024),
                .init(title: "2023", value: 2023)
            ]
            // Earlier decade ranges
            let otherYears: [Item] = [
                .init(title: "2020s", value: 2020),
                .init(title: "2010s", value: 2010),
                .init(title: "2000s", value: 2000),
                .init(title: "1990s", value: 1990),
                .init(title: "1980s", value: 1980),
                .init(title: "1970s", value: 1970),
                .init(title: "1960s", value: 1960),
                .init(title: "1950s", value: 1950),
                .init(title: "1940s", value: 1940),
                .init(title: "1930s", value: 1930)
            ]
            let allItems = recentYears + otherYears
            return Section(
                items: allItems,
                title: "Release date",
                selectionRule: .range([recentYears, otherYears])
            )
        }()
    }
}

final class AdvancedSearchViewModel: ObservableObject {
    @Published private(set) var sections: [Section] = [
        .genres, .rating, .votes, .runtime, .releaseDate
    ]
        
    @Published private var selectedItems: [Section: [Item]] = [:]
        
    func selectItem(_ item: Item, in section: Section) {
        switch section.selectionRule {
        case .multiple:
            var current = selectedItems[section] ?? []
            if let index = current.firstIndex(of: item) {
                current.remove(at: index)
            } else {
                current.append(item)
            }
            selectedItems[section] = current

        case .cumulative:
            var current = selectedItems[section] ?? []
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
            var current = selectedItems[section]?.filter { rangeGroup.contains($0) } ?? []

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
    }
    
    func isSelected(_ item: Item, in section: Section) -> Bool {
        selectedItems[section]?.contains(item) ?? false
    }
}

struct AdvancedSearchView: View {
    @StateObject var viewModel: AdvancedSearchViewModel
    
    private let columns = [
      GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    @ViewBuilder
    private func createButtonView(_ item: AdvancedSearchViewModel.Item,
                                  section: AdvancedSearchViewModel.Section) -> some View {
        let button = Button(item.title) {
            viewModel.selectItem(item, in: section)
        }
        if viewModel.isSelected(item, in: section) {
            button.buttonStyle(.borderedProminent)
        } else {
            button.buttonStyle(.bordered)
        }
    }
        
    var body: some View {
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
            }.padding(.horizontal)
        }
    }
}

#Preview {
    AdvancedSearchView(viewModel: .init())
}
