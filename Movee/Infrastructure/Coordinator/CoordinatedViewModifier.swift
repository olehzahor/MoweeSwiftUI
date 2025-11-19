//
//  CoordinatedViewModifier.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

struct CoordinatedModifier<C: Coordinator>: ViewModifier {
    @ObservedObject var coordinator: C

    func body(content: Content) -> some View {
        content
            .navigationDestination(for: C.RouteType.self) { route in
                route.view
            }
            .sheet(item: $coordinator.presentedSheet) { route in
                NavigationStack {
                    route.view
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    coordinator.dismiss()
                                }
                            }
                        }
                }
            }
            .fullScreenCover(item: $coordinator.presentedFullScreen) { route in
                NavigationStack {
                    route.view
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    coordinator.dismiss()
                                }
                            }
                        }
                }
            }
    }
}

extension View {
    func coordinated<C: Coordinator>(with coordinator: C) -> some View {
        modifier(CoordinatedModifier(coordinator: coordinator))
    }
}
