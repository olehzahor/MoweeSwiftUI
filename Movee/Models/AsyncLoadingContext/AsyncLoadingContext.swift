//
//  AsyncLoadingContext.swift
//  Movee
//
//  Created by Oleh on 18.10.2025.
//

struct AsyncLoadingContext<T: Hashable>: Equatable {
    private var states: [T: State] = [:]
    
    subscript(section: T) -> State {
        get {
            states[section] ?? .idle
        }
        set {
            states[section] = newValue
        }
    }
    
    mutating func cancelAll() {
        states.removeAll()
    }
}
