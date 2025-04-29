//
//  ViewLoadingState.swift
//  Movee
//
//  Created by user on 4/28/25.
//

import SwiftUI
import Combine

struct ViewLoadingState<T: Hashable> {
    private(set) var loaded: [T] = []
    private(set) var loading: [T] = []
    private(set) var empty: [T] = []
    private(set) var errors: [T: Error] = [:]
    
    private var description: String {
        """
        loaded: \(loaded)
        loading: \(loading)
        empty: \(empty)
        errors: \(Array(errors.keys))
        """
    }
    
    func isLoaded(_ section: T) -> Bool {
        loaded.contains(section)
    }
    
    mutating func setLoaded(_ section: T, isEmpty: Bool) {
        loaded.append(section)
        loading.removeAll { $0 == section }
        if isEmpty {
            empty.append(section)
        } else {
            empty.removeAll { $0 == section }
            Logger.shared.log("Set loaded: \(section), isEmpty: \(isEmpty)\n\(description)", level: .info)
        }
        Logger.shared.log("Current state after setLoaded:\n\(description)", level: .debug)
    }
    
    func isLoading(_ section: T) -> Bool {
        loading.contains(section)
    }
    
    mutating func setLoading(_ section: T) {
        loading.append(section)
        loaded.removeAll { $0 == section }
        Logger.shared.log("Set loading: \(section)\n\(description)", level: .info)
    }
    
    func isEmpty(_ section: T) -> Bool {
        empty.contains(section)
    }
        
    func getError(_ section: T) -> Error? {
        errors[section]
    }
    
    func getErrorMessage(_ section: T) -> String? {
        errors[section]?.localizedDescription
    }
    
    mutating func setError(_ section: T, _ error: Error) {
        errors[section] = error
        loaded.removeAll { $0 == section }
        Logger.shared.log("Set error: \(error) for section: \(section)\n\(description)", level: .error)
    }
}
