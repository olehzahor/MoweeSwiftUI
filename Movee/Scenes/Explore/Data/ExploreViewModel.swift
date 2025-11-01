//
//  ExploreViewModel.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import Combine
import Foundation

@MainActor @Observable
final class NewExploreViewModel: SectionFetchable {
    var fetchableSections: [NewMediasSection]

    var medias: [NewMediasSection: [Media]] = [:]
    
    var sectionsContext = AsyncLoadingContext<NewMediasSection>()
    var maxConcurrentFetches: Int { 2 }

    func fetchConfig(for section: NewMediasSection) -> AnyFetchConfig? {
        AnyFetchConfig(
            FetchConfig {
                try await section.dataProvider?.fetch(page: 1) ?? .wrap([])
            } onSuccess: { [weak self] response in
                self?.medias[section] = response.results
            } isEmpty: { response in
                response.results.isEmpty
            }
        )
    }

    init(sections: [NewMediasSection]) {
        fetchableSections = sections
    }
}

class ExploreViewModel: ObservableObject {
    @Published var sections: [MediasSection]
    
    @Published var medias: [MediasSection: [Media]] = [:]
    
    @Published private(set) var state = ViewLoadingState<MediasSection>()
    
    private var cancellables = Set<AnyCancellable>()
            
    func fetchMedias(section: MediasSection) {
        guard !state.isLoading(section) else { return }
        
        state.setLoading(section)

        section.publisherBuilder?(1)
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    state.setError(section, error)
                }
            } receiveValue: { [unowned self] response in
                medias[section] = response.results
                state.setLoaded(section, isEmpty: response.results.isEmpty)
            }.store(in: &cancellables)
    }
        
    init(sections: [MediasSection]) {
        self.sections = sections
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
