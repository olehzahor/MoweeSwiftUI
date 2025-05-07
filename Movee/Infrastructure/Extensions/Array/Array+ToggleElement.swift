//
//  Array+ToggleElement.swift
//  Movee
//
//  Created by user on 5/7/25.
//

import Foundation

extension Array where Element: Equatable {
    /// Toggles the presence of an element: removes it if present, appends it if absent.
    mutating func toggleElement(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        } else {
            append(element)
        }
    }
}
