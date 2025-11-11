//
//  Loadable.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

struct LoadableModifier: ViewModifier {
    @Environment(\.isLoading) private var isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .redacted(reason: .placeholder)
                .shimmering()
                .disabled(true)
        } else {
            content
        }
    }
}

extension View {
    func loadable() -> some View {
        self.modifier(LoadableModifier())
    }
}
