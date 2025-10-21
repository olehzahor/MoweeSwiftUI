//
//  State.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

extension SectionsLoadingContext {
    enum State {
        case idle
        case loading(task: Task<Void, Never>?)
        case loaded(isEmpty: Bool)
        case error(Error)
    }
}

extension SectionsLoadingContext.State {
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
    
    var isEmpty: Bool {
        if case .loaded(isEmpty: true) = self { return true }
        return false
    }
    
    var error: Error? {
        if case .error(let error) = self { return error }
        return nil
    }
    
    var task: Task<Void, Never>? {
        if case .loading(let task) = self { return task }
        return nil
    }
    
//    static func == (lhs: State, rhs: State) -> Bool {
//        switch (lhs, rhs) {
//        case (.idle, .idle):
//            return true
//        case (.loading, .loading):
//            return true
//        case (.loaded(let a), .loaded(let b)):
//            return a == b
//        case (.error, .error):
//            return true  // Could compare error descriptions if needed
//        default:
//            return false
//        }
//    }
}
