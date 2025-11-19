//
//  Coordinator.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

protocol Route: Hashable, Identifiable {
    associatedtype Destination: View
    @ViewBuilder var view: Destination { get }
}

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject, ObservableObject {
    associatedtype RouteType: Route
    
    var path: NavigationPath { get set }
    var presentedSheet: RouteType? { get set }
    var presentedFullScreen: RouteType? { get set }
    
    func push(_ route: RouteType)
    func pop()
    func popToRoot()
    func present(_ route: RouteType, style: PresentationStyle)
    func dismiss()
}

enum PresentationStyle {
    case sheet
    case fullScreenCover
}

extension Coordinator {
    func push(_ route: RouteType) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func present(_ route: RouteType, style: PresentationStyle = .sheet) {
        switch style {
        case .sheet:
            presentedSheet = route
        case .fullScreenCover:
            presentedFullScreen = route
        }
    }
    
    func dismiss() {
        presentedSheet = nil
        presentedFullScreen = nil
    }
}

// MARK: - Coordinated View Modifier

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

// MARK: - Environment Key

private struct CoordinatorKey: EnvironmentKey {
    static let defaultValue: AppCoordinator? = nil
}

extension EnvironmentValues {
    var coordinator: AppCoordinator? {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}

extension View {
    func coordinated<C: Coordinator>(with coordinator: C) -> some View {
        modifier(CoordinatedModifier(coordinator: coordinator))
    }
}

// MARK: - Coordinated Navigation Stack

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

// MARK: - App Coordinator

final class AppCoordinator: Coordinator {
    typealias RouteType = AppRoute
    
    @Published var path = NavigationPath()
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreen: AppRoute?
    
    init() {}
}

enum AppRoute: Route {
    case mediaDetails(Media)
    case seasonDetails(Int, Season)
    case review(String, Review)

    var id: Self { self }

    @ViewBuilder
    var view: some View {
        switch self {
        case .mediaDetails(let media):
            MediaDetailsView(media: media)
        case .seasonDetails(let tvShowID, let season):
            SeasonDetailsView(tvShowID: tvShowID, season: season)
        case .review(let title, let review):
            ReviewView(mediaTitle: title, review: review)
        }
    }
}
