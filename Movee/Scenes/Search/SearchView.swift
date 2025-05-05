//
//  SearchView.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUI
import Combine

// MARK: - JSON Config for Collections
private struct ListConfig: Decodable {
    let mediaType: String?
    let name: String
    let path: String?
    let query: String?
}

private struct ListsRoot: Decodable {
    let discoverLists: [ListConfig]
}

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16, alignment: .top),
        count: 2
    )
    
    @ViewBuilder
    private func destinationView(for result: SearchResult) -> some View {
        switch viewModel.getNavigationDestination(for: result) {
        case .media(let media):
            MediaDetailsView(media: media)
        case .person(let person):
            PersonDetailsView(person: person)
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.results.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.collections, id: \.title) { collection in
                                NavigationLink {
                                    MediasListView(section: collection.section)
                                } label: {
                                    CustomCollectionView(collection: collection)
                                }
                                
                            }
                        }.padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(viewModel.results) { result in
                            NavigationLink {
                                destinationView(for: result)
                            } label: {
                                MediaRowView(data: .init(searchResult: result))
                            }.transaction { $0.animation = nil }
                        }
                    }.listStyle(.plain)
                }
            }
            
        }
        .animation(.default, value: viewModel.results)
        .searchable(text: $viewModel.query, prompt: "Search movies, TV shows, people")
        .navigationTitle("Search")
    }
}

// MARK: - ViewModel
// TODO: consider using MediasSection here; maybe adding image
struct CustomMediaCollection {
    typealias PublisherBuilder = (Int) -> AnyPublisher<PaginatedResponse<Media>, Error>
    
    let title: String
    let image: ImageResource?
    var publisherBuilder: PublisherBuilder?
    
    var section: MediasSection {
        .init(title: title, publisherBuilder: publisherBuilder)
    }
}

private class SearchViewModel: ObservableObject {
    enum NavigationDestination {
        case media(Media)
        case person(MediaPerson)
    }
    
    @Published var query: String = ""
    @Published var results: [SearchResult] = [] {
        didSet {
            Logger.shared.log("Received search results: \(results.map({ $0.id }))")
        }
    }
    
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
    
    func search() {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            results = []
            return
        }
        apiClient.searchMulti(query: query)
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Search error:", error)
                }
            }, receiveValue: { [weak self] searchResults in
                self?.results = searchResults
            })
            .store(in: &cancellables)
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
        
        collections = root.discoverLists.map { config in
            CustomMediaCollection(
                title: config.name,
                image: nil,
                publisherBuilder: { page in
                    if config.mediaType == "tv" {
                        TMDBAPIClient.shared
                            .fetchCustomList(
                                endpoint: config.path ?? "",
                                query: config.query ?? "",
                                page: page
                            )
                            .map { response in
                                return response.map(Media.init(tvShow:))
                            }
                            .eraseToAnyPublisher()
                    } else {
                        TMDBAPIClient.shared
                            .fetchCustomList(
                                endpoint: config.path ?? "",
                                query: config.query ?? "",
                                page: page
                            )
                            .map { response in
                                return response.map(Media.init(movie:))
                            }
                            .eraseToAnyPublisher()
                    }
                }
            )
        }
    }
}

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
                    Color.secondary
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
