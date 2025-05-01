//
//  ListSeparatorTrailingAlignment.swift
//  Movee
//
//  Created by user on 5/1/25.
//

import SwiftUICore

struct ListSeparatorTrailingAlignment: ViewModifier {
    func body(content: Content) -> some View {
        content.alignmentGuide(.listRowSeparatorTrailing) { d in
            d[.trailing]
        }
    }
}

extension View {
    /// Aligns a view's trailing edge with the list row separator's trailing edge
    func listSeparatorTrailingAligned() -> some View {
        modifier(ListSeparatorTrailingAlignment())
    }
}
