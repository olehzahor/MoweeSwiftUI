//
//  SectionsLoadingContext.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

struct SectionsLoadingContext<T: Hashable> {
    private var states: [T: State] = [:]
    
    subscript(section: T) -> State {
        get {
            states[section] ?? .idle
        }
        set {
            if case .loading(let task) = states[section] {
                task?.cancel()
            }
            states[section] = newValue
        }
    }
    
    mutating func cancelAll() {
        for (_, state) in states {
            if case .loading(let task) = state {
                task?.cancel()
            }
        }
        states.removeAll()
    }
}
