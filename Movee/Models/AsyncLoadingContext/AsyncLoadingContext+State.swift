//
//  AsyncLoadingContext+State.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

extension AsyncLoadingContext {
    enum State {
        case idle
        case loading
        case loaded(isEmpty: Bool)
        case error(Error)
    }
}

extension AsyncLoadingContext.State {
    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var isAwaitingData: Bool {
        isIdle || isLoading
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
}

extension AsyncLoadingContext.State: Equatable {
    static func == (lhs: AsyncLoadingContext.State, rhs: AsyncLoadingContext.State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.loaded(let a), .loaded(let b)):
            return a == b
        case (.error(let a), .error(let b)):
            return a.localizedDescription == b.localizedDescription
        default:
            return false
        }
    }
}
