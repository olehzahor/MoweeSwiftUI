//
//  HideWhenModifier.swift
//  Movee
//
//  Created by user on 4/28/25.
//

import SwiftUI

// MARK: - Conditional visibility helper
struct HideWhenModifier: ViewModifier {
    let isHidden: Bool
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if !isHidden {
            content
        }
    }
}

extension View {
    func hidden(_ condition: Bool) -> some View {
        modifier(HideWhenModifier(isHidden: condition))
    }
}
