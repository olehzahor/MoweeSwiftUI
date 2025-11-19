//
//  CoordinatorProtocol.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

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
