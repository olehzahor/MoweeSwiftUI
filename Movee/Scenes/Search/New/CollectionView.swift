//
//  CollectionView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

protocol CollectionDataRepositoryProtocol {
    func fetchLists() async throws -> [MediasList]
}

struct DiscoverCollectionDataRepository: CollectionDataRepositoryProtocol {
    private let network = NetworkClient2(decoder: JSONDecoder())
    
    func fetchLists() async throws -> [MediasList] {
        try await network.request(Mowee.Lists()).discoverLists
    }
}

struct StaticCollectionDataRepository: CollectionDataRepositoryProtocol {
    let lists: [MediasList]
    
    func fetchLists() async throws -> [MediasList] {
        lists
    }
}

@MainActor @Observable
final class CollectionViewModel: SectionFetchable {
    private let repo: CollectionDataRepositoryProtocol
    
    private(set) var lists: [MediasList] = []
    
    enum Section { case main }
    var fetchableSections: [Section] = [.main]
    var sectionsContext = AsyncLoadingContext<Section>()
    var maxConcurrentFetches: Int { 1 }

    func fetchConfig(for section: Section) -> AnyFetchConfig? {
        .init(.init(fetcher: { [repo] in
            try await repo.fetchLists()
        }, onSuccess: { result in
            self.lists = result
        }))
    }
    
    init(lists: [MediasList]) {
        self.repo = StaticCollectionDataRepository(lists: lists)
    }
    
    init(repo: CollectionDataRepositoryProtocol) {
        self.repo = repo
    }
    
    convenience init() {
        self.init(repo: DiscoverCollectionDataRepository())
    }
}

struct CollectionItemView: View {
    struct Data {
        let name: String
        
        init(_ list: MediasList) {
            self.name = list.name
        }
    }
    
    let item: Data
    
    var body: some View {
        Text(item.name)
            .textStyle(.smallTitle)
            .multilineTextAlignment(.center)
            .padding()
            .frame(minHeight: 60)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background {
                Color(UIColor.secondarySystemBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CollectionGridView: View {
    @Environment(\.placeholder) private var placeholder: Bool

    let collections: [MediasList]
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 2
    )

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(collections, id: \.self) { collection in
                CollectionItemView(item: .init(collection))
            }
        }
    }
}

struct CollectionView: View {
    private let viewModel = CollectionViewModel()
    
    var body: some View {
        ScrollView {
            CollectionGridView(collections: viewModel.lists)
                .padding(.horizontal)
                .onFirstAppear {
                    viewModel.fetchInitialData()
                }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    CollectionView()
}
