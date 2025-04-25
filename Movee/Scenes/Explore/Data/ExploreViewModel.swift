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
    @Published var isLoading: [MediasSection: Bool] = [:]
    @Published var errors: [MediasSection: Error] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private func isLoading(_ section: MediasSection) -> Bool {
        isLoading[section] ?? false
    }
        
    func fetchMedias(section: MediasSection) {
        guard !isLoading(section) else { return }
        
        isLoading[section] = true

        section.publisherBuilder(1)
            .sink { [unowned self] completion in
                isLoading[section] = false
                if case .failure(let error) = completion {
                    errors[section] = error
                }
            } receiveValue: { [unowned self] response in
                if !response.results.isEmpty {
                    isLoading[section] = false
                    medias[section] = response.results
                }
            }.store(in: &cancellables)
    }
    
    func isSectionLoaded(_ section: MediasSection) -> Bool {
        !((medias[section] ?? []).isEmpty)
    }
    
    init(sections: [MediasSection]) {
        self.sections = sections
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
