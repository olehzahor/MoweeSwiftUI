//
//  PlaceholderEnvironmentKey.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

private struct PlaceholderEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var placeholder: Bool {
        get { self[PlaceholderEnvironmentKey.self] }
        set { self[PlaceholderEnvironmentKey.self] = newValue }
    }
}

extension View {
    func placeholder() -> some View {
        self.environment(\.placeholder, true)
    }
}
