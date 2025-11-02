//
//  ShimmerModifier.swift
//  Movee
//
//  Created by user on 11/02/25.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    func body(content: Content) -> some View {
        TimelineView(.animation) { timeline in
            let progress = timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 2)
            let phase = progress <= 1.0 ? progress : 2.0 - progress

            content
                .overlay(
                    Color(.systemBackground)
                        .blendMode(.sourceAtop)
                        .opacity((1 - phase) * 0.5)
                )
                .compositingGroup()
        }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}
