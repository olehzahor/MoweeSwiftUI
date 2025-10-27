//
//  PostponedAnimationModifier.swift
//  Movee
//
//  Created on 27.10.2025.
//

import SwiftUI

struct PostponedAnimationModifier<V: Equatable>: ViewModifier {
    let delay: TimeInterval
    let animation: Animation?
    let value: V

    @State private var appearTime: Date?

    private var shouldAnimate: Bool {
        guard let appearTime else { return false }
        return Date().timeIntervalSince(appearTime) > delay
    }

    func body(content: Content) -> some View {
        content
            .animation(shouldAnimate ? animation : nil, value: value)
            .onAppear {
                if appearTime == nil {
                    appearTime = Date()
                }
            }
    }
}

extension View {
    func postponedAnimation<V: Equatable>(
        _ delay: TimeInterval,
        _ animation: Animation?,
        value: V
    ) -> some View {
        modifier(PostponedAnimationModifier(delay: delay, animation: animation, value: value))
    }
}
