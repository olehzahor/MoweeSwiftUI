//
//  CollectionGridView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CollectionGridView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    let items: [Data]
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 2
    )

    var body: some View {
        LazyVGrid(columns: columns) {
            if placeholder {
                ForEach(0..<5, id: \.self) { _ in
                    CollectionItemView(item: .init(name: .placeholder(.short)))
                }
                .loadable()
            } else {
                ForEach(items, id: \.name) { item in
                    NavigationLink {
                        switch item.destination {
                        case .section(let section):
                            NewMediasListView(section: section)
                        case .nestedLists(let nested):
                            CollectionView(title: item.name, lists: nested)
                        case .none:
                            EmptyView()
                        }
                    } label: {
                        CollectionItemView(item: .init(item))
                    }
                }
            }
        }
    }
    
    init(items: [Data]) {
        self.items = items
    }
    
    init(_ lists: [MediasList]) {
        self.items = lists.map { .init($0) }
    }
}

extension CollectionGridView {
    struct Data {
        enum Destination {
            case nestedLists([MediasList])
            case section(NewMediasSection)
        }
        
        let name: String
        let destination: Destination?
        
        init(name: String, destination: Destination?) {
            self.name = name
            self.destination = destination
        }
        
        init(_ list: MediasList) {
            self.name = list.name
            if let section = list.section {
                self.destination = .section(section)
            } else if let nested = list.nestedLists {
                self.destination = .nestedLists(nested)
            } else {
                self.destination = nil
            }
        }
    }
}
