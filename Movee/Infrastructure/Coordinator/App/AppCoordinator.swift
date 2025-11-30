//
//  AppCoordinator.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI
import Factory

@MainActor
final class AppCoordinator: Coordinator {
    typealias RouteType = AppRoute

    @Published var path = NavigationPath()
    @Published var presentedSheet: AppRoute?
    @Published var presentedFullScreen: AppRoute?

    let logger: CoordinatorLogger?

    init(logger: CoordinatorLogger? = Container.shared.logger()) {
        self.logger = logger
    }
}
