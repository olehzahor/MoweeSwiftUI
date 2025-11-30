//
//  CollectionGridView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CollectionGridView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    @Environment(\.coordinator) private var coordinator

    let items: [Data]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 2
    )

    func handleSelection(_ item: Data) {
        guard let coordinator else { return }
        switch item.destination {
        case .section(let section):
            coordinator.push(.mediasList(section))
        case .nestedLists(let nested):
            coordinator.push(.collection(item.name, nested))
        case .none:
            break
        }
    }

    var body: some View {
        LazyVGrid(columns: columns) {
            if placeholder {
                ForEach(0..<20, id: \.self) { _ in
                    CollectionItemView(item: .init(name: .placeholder(.custom(40))))
                        .loadable()
                }
            } else {
                ForEach(items, id: \.name) { item in
                    Button {
                        handleSelection(item)
                    } label: {
                        CollectionItemView(item: .init(item))
                    }
                }
            }
        }
        .fallible()
    }
    
    init(items: [Data]) {
        self.items = items
    }
    
    init(_ lists: [CollectionList]) {
        self.items = lists.map { .init($0) }
    }
}

extension CollectionGridView {
    struct Data {
        enum Destination {
            case nestedLists([CollectionList])
            case section(MediasSection)
        }
        
        let name: String
        let destination: Destination?
        
        init(name: String, destination: Destination?) {
            self.name = name
            self.destination = destination
        }
        
        init(_ list: CollectionList) {
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
