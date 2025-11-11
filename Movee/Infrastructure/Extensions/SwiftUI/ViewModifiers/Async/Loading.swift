//
//  IsLoadingEnvironmentKey.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

private struct IsLoadingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingEnvironmentKey.self] }
        set { self[IsLoadingEnvironmentKey.self] = newValue }
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        self
            .environment(\.placeholder, isLoading)
            .environment(\.isLoading, isLoading)
    }
}
