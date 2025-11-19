//
//  CoordinatedNavigationStack.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

struct CoordinatedNavigationStack<Content: View>: View {
    @ObservedObject var coordinator: AppCoordinator
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            content()
                .coordinated(with: coordinator)
        }
        .environment(\.coordinator, coordinator)
    }
}
