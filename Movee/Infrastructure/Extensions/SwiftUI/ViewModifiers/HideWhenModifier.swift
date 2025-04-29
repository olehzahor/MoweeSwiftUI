//
//  HideWhenModifier.swift
//  Movee
//
//  Created by user on 4/28/25.
//

import SwiftUI

// MARK: - Conditional visibility helper
struct HideWhenModifier: ViewModifier {
    let shouldHide: Bool
    @ViewBuilder
    func body(content: Content) -> some View {
        if shouldHide {
            EmptyView()
        } else {
            content
        }
    }
}

extension View {
    /// Hides the view (replacing it with `EmptyView`) when `condition` is true.
    func hideWhen(_ condition: Bool) -> some View {
        modifier(HideWhenModifier(shouldHide: condition))
    }
}
