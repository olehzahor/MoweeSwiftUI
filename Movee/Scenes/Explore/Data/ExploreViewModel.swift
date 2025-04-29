//
//  ExploreViewModel.swift
//  Movee
//
//  Created by user on 4/4/25.
//

import Combine
import Foundation

class ExploreViewModel: ObservableObject {
    @Published var sections: [MediasSection]
    
    @Published var medias: [MediasSection: [Media]] = [:]
    
    @Published private(set) var state = ViewLoadingState<MediasSection>()
    
    private var cancellables = Set<AnyCancellable>()
            
    func fetchMedias(section: MediasSection) {
        guard !state.isLoading(section) else { return }
        
        state.setLoading(section)

        section.publisherBuilder(1)
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
