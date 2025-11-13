//
//  SearchView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Combine

protocol ViewModel {
    associatedtype Section
    func fetch(_ section: Section)
    func fetchMoreIfNeeded<T>(_ item: T, from section: Section)
}

// MARK: - JSON Config for Collections
private struct ListConfig: Decodable {
    enum MediaType: String, Decodable {
        case movie, tv, themedList
    }
    
    let mediaType: MediaType?
    let name: String
    let path: String?
    let query: String?
    //TODO: @DefaultEmptyArray
    let nestedLists: [ListConfig]?
}

private struct ListsRoot: Decodable {
    let discoverLists: [ListConfig]
}

struct SearchCollectionsView: View {
    @State var collections: [CustomMediaCollection]
    var title: String?
    var isNested: Bool = false

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 2
    )
    
    private func isSearchHistoryAvailable() -> Bool {
        SearchHistoryManager.shared.count() > 0
    }

    var body: some View {
        ScrollView {
            VStack {
                if !isNested {
                    LazyVGrid(columns: columns) {
                        NavigationLink {
                            AdvancedSearchView()
                        } label: {
                            CustomCollectionView(collection: .init(title: "Advanced search"))
                        }
                        
                        if isSearchHistoryAvailable() {
                            NavigationLink {
                                let section = MediasSection(title: "Search history") { _ in
                                    SearchHistoryManager.shared.itemsPublisher
                                        .map {
                                            .wrap($0
                                                .sorted(by: { $0.added >= $1.added })
                                                .map { Media($0.media) })
                                        }
                                        .setFailureType(to: Error.self)
                                        .eraseToAnyPublisher()
                                }
                                MediasListView(section: section)
                            } label: {
                                CustomCollectionView(collection: .init(title: "Search history"))
                            }
                        }
                    }
                    
                    Divider()
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(collections, id: \.title) { collection in
                        NavigationLink {
                            if let nestedCollections = collection.nested,
                               !nestedCollections.isEmpty {
                                SearchCollectionsView(collections: nestedCollections, title: collection.title, isNested: true)
                            } else {
                                MediasListView(section: collection.section)
                            }
                        } label: {
                            CustomCollectionView(collection: collection)
                        }
                        
                    }
                }
            }.padding(.horizontal)
        }
        .navigationTitle(title ?? "Discover")
        .navigationBarTitleDisplayMode(isNested ? .inline : .large)
    }
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var isSearchActive: Bool = false
            
    @ViewBuilder
    private func destinationView(for result: SearchResult) -> some View {
        switch viewModel.getNavigationDestination(for: result) {
        case .media(let media):
            MediaDetailsView(media: media).onFirstAppear {
                viewModel.saveToHistory(media)
            }
        case .person(let person):
            PersonDetailsView(person: person)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !isSearchActive {
                    SearchCollectionsView(collections: viewModel.collections)
                } else {
                    VStack(spacing: 0) {
                        Picker("", selection: $viewModel.selectedScope) {
                            ForEach(viewModel.searchScopes) { scope in
                                Text(scope.title).tag(scope)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        //.background(.ultraThinMaterial)
                        
                        Divider()
                        
                        List {
                            ForEach(viewModel.results) { result in
                                NavigationLink {
                                    destinationView(for: result)
                                } label: {
                                    MediaRowView(data: .init(searchResult: result))
                                }
                                .onAppear {
                                    viewModel.loadMoreResultsIfNeeded(for: result)
                                }
                                .transaction { $0.animation = nil }
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .animation(.default, value: viewModel.results)
                        
                    }
                }
            }
        }
        .searchable(
            text: $viewModel.query,
            isPresented: $isSearchActive,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search movies, TV shows, people"
        )
    }
}

// MARK: - ViewModel
// TODO: consider using MediasSection here; maybe adding image
struct CustomMediaCollection {
    typealias PublisherBuilder = (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>
    
    var title: String
    var image: ImageResource?
    var publisherBuilder: PublisherBuilder?
    var nested: [CustomMediaCollection]?
    
    var section: MediasSection {
        .init(title: title, publisherBuilder: publisherBuilder)
    }
}

private class SearchViewModel: ObservableObject {
    enum SearchScope: String, CaseIterable, Identifiable {
        case all = "All Results"
        case movies = "Movies"
        case tvShows = "TV Shows"
        case people = "People"
        
        var id: String { rawValue }
        var title: String { rawValue }
    }
    
    @Published var selectedScope: SearchScope = .all {
        didSet {
            currentPage = 1
            totalPages = 1
            isLoadingPage = false
            search()
        }
    }
    
    var searchScopes: [SearchScope] = SearchScope.allCases
    
    enum NavigationDestination {
        case media(Media)
        case person(MediaPerson)
    }
    
    @Published var query: String = "" {
        didSet {
            if query != oldValue {
                currentPage = 1
                totalPages = 1
            }
        }
    }
    
    @Published var results: [SearchResult] = [] {
        didSet {
            Logger.shared.log("Received search results: \(results.map({ $0.id }))")
        }
    }
    @Published private(set) var currentPage: Int = 1
    @Published private(set) var totalPages: Int = 1
    private var isLoadingPage = false
    
    private var cancellables = Set<AnyCancellable>()
    private let apiClient = TMDBAPIClient.shared
    
    @Published var collections: [CustomMediaCollection] = []
    
    init() {
        $query
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.search()
            }
            .store(in: &cancellables)
        loadCollections()
    }
    
    func saveToHistory(_ media: Media) {
        Task {
            await SearchHistoryManager.shared.addToHistory(media)
        }
    }
    
    func getNavigationDestination(for result: SearchResult) -> NavigationDestination {
        switch result.result {
        case .movie(let movie):
            return .media(.init(movie: movie))
        case .tv(let tVShow):
            return .media(.init(tvShow: tVShow))
        case .person(let person):
            return .person(.init(person: person))
        }
    }
    
    func search(page: Int = 1) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        
        // Prevent overlapping page loads
        guard !isLoadingPage else { return }
        isLoadingPage = true
        
        let publisher: AnyPublisher<PaginatedResponse<SearchResult>, any Error> = switch selectedScope {
        case .all:
            apiClient.searchMulti(query: query, page: page)
        case .movies:
            apiClient.searchMovies(query: query, page: page)
                .map { $0.map { SearchResult(.movie($0)) } }
                .eraseToAnyPublisher()
        case .tvShows:
            apiClient.searchTVShows(query: query, page: page)
                .map { $0.map { SearchResult(.tv($0)) } }
                .eraseToAnyPublisher()
        case .people:
            apiClient.searchPeople(query: query, page: page)
                .map { $0.map { SearchResult(.person($0)) } }
                .eraseToAnyPublisher()
        }
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Search error:", error)
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                
                self.currentPage = response.page
                self.totalPages = response.total_pages
                
                if page == 1 {
                    self.results = response.results
                } else {
                    self.results += response.results
                }
                self.isLoadingPage = false
            })
            .store(in: &cancellables)
    }
    
    func loadMoreResultsIfNeeded(for result: SearchResult) {
        guard let last = results.last, last.id == result.id,
              currentPage < totalPages else { return }
        search(page: currentPage + 1)
    }
    
    private func loadCollections() {
        guard let url = Bundle.main.url(
            forResource: "mowee-542f8-default-rtdb-export",
            withExtension: "json"
        ),
              let data = try? Data(contentsOf: url),
              let root = try? JSONDecoder().decode(ListsRoot.self, from: data)
        else {
            return
        }
        
        collections = root.discoverLists.map(makeCollection)
    }
    
    private func makeCollections(from configs: [ListConfig]?) -> [CustomMediaCollection]? {
        configs?.map(makeCollection)
    }
    
    private func makeCollection(from config: ListConfig) -> CustomMediaCollection {
        CustomMediaCollection(
            title: config.name,
            image: nil,
            publisherBuilder: { page in
                switch config.mediaType ?? .movie {
                case .tv:
                    return TMDBAPIClient.shared
                        .fetchCustomList(
                            endpoint: config.path ?? "",
                            query: config.query ?? "",
                            page: page
                        )
                        .map { $0.map(Media.init(tvShow:)) }
                        .eraseToAnyPublisher()
                case .themedList:
                    let rawPath = config.path?.replacingOccurrences(of: "list/", with: "")
                    let listID = Int(rawPath ?? "") ?? -1
                    return TMDBAPIClient.shared
                        .fetchList(listID: listID, page: page)
                        .map { $0.paginatedResponse.compactMap(\.media) }
                        .eraseToAnyPublisher()

                default:
                    return TMDBAPIClient.shared
                        .fetchCustomList(
                            endpoint: config.path ?? "",
                            query: config.query ?? "",
                            page: page
                        )
                        .map { $0.map(Media.init(movie:)) }
                        .eraseToAnyPublisher()
                }
            },
            nested: makeCollections(from: config.nestedLists)
        )
    }}

#Preview {
    SearchView()
}

struct CustomCollectionView: View {
    var collection: CustomMediaCollection
    
    var body: some View {
        Text(collection.title)
            .foregroundStyle(collection.image == nil ? Color(UIColor.label) : .white)
            .textStyle(.smallTitle)
            .padding()
            .multilineTextAlignment(.center)
            .frame(
                maxWidth: .infinity,
                minHeight: collection.image == nil ? 60 : 80,
                maxHeight: .infinity)
            .background {
                if let image = collection.image {
                    ZStack {
                        Image(image)
                            .resizable()
                            .scaledToFill()
                        Color.black.opacity(0.3)
                    }
                } else {
                    Color(UIColor.secondarySystemBackground)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
