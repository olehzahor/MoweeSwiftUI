//
//  ViewFirstAppearModifier.swift
//  Movee
//
//  Created by user on 4/14/25.
//

import SwiftUI

public extension View {
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(ViewFirstAppearModifier(perform: action))
    }

    func onFirstAppear(perform action: @escaping @MainActor () async -> Void) -> some View {
        modifier(AsyncViewFirstAppearModifier(perform: action))
    }
}

struct ViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: () -> Void

    init(perform action: @escaping () -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            action()
        }
    }
}

struct AsyncViewFirstAppearModifier: ViewModifier {
    @State private var didAppearBefore = false
    private let action: @MainActor () async -> Void

    init(perform action: @escaping @MainActor () async -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.task {
            guard !didAppearBefore else { return }
            didAppearBefore = true
            await action()
        }
    }
}
