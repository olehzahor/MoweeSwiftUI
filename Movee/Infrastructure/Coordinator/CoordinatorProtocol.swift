//
//  CoordinatorProtocol.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

@MainActor
protocol Coordinator: AnyObject, ObservableObject {
    associatedtype RouteType: Route

    var path: NavigationPath { get set }
    var presentedSheet: RouteType? { get set }
    var presentedFullScreen: RouteType? { get set }
    var logger: CoordinatorLogger? { get }

    func push(_ route: RouteType)
    func pop()
    func popToRoot()
    func present(_ route: RouteType, style: PresentationStyle)
    func dismiss()
}

@MainActor
extension Coordinator {
    func push(_ route: RouteType) {
        let currentDepth = path.count
        path.append(route)
        logger?.logCoordinatorInfo("Push: \(route) (depth: \(currentDepth) → \(path.count))")
    }

    func pop() {
        guard !path.isEmpty else {
            logger?.logCoordinatorInfo("Pop: ignored (path is empty)")
            return
        }
        let previousDepth = path.count
        path.removeLast()
        logger?.logCoordinatorInfo("Pop: removed route (depth: \(previousDepth) → \(path.count))")
    }

    func popToRoot() {
        let routesRemoved = path.count
        guard routesRemoved > 0 else {
            logger?.logCoordinatorInfo("Pop to root: ignored (already at root)")
            return
        }
        path.removeLast(routesRemoved)
        logger?.logCoordinatorInfo("Pop to root: removed \(routesRemoved) route(s)")
    }

    func present(_ route: RouteType, style: PresentationStyle = .sheet) {
        switch style {
        case .sheet:
            if let previousSheet = presentedSheet {
                presentedSheet = route
                logger?.logCoordinatorInfo("Present sheet: \(route) (replaced: \(previousSheet))")
            } else {
                presentedSheet = route
                logger?.logCoordinatorInfo("Present sheet: \(route)")
            }
        case .fullScreenCover:
            if let previousFullScreen = presentedFullScreen {
                presentedFullScreen = route
                logger?.logCoordinatorInfo("Present full screen: \(route) (replaced: \(previousFullScreen))")
            } else {
                presentedFullScreen = route
                logger?.logCoordinatorInfo("Present full screen: \(route)")
            }
        }
    }

    func dismiss() {
        var dismissed: [String] = []

        if let sheet = presentedSheet {
            dismissed.append("sheet(\(sheet))")
            presentedSheet = nil
        }

        if let fullScreen = presentedFullScreen {
            dismissed.append("fullScreen(\(fullScreen))")
            presentedFullScreen = nil
        }

        if dismissed.isEmpty {
            logger?.logCoordinatorInfo("Dismiss: ignored (nothing presented)")
        } else {
            logger?.logCoordinatorInfo("Dismiss: \(dismissed.joined(separator: ", "))")
        }
    }
}

@MainActor
public protocol CoordinatorLogger: Sendable {
    func logCoordinatorInfo(_ message: String)
    func logCoordinatorError(_ message: String)
}

extension Logger: CoordinatorLogger {
    public func logCoordinatorInfo(_ message: String) {
        log(message, level: .info)
    }

    public func logCoordinatorError(_ message: String) {
        log(message, level: .error)
    }
}
