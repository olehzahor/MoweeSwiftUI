//
//  CoordinatorEnvironment.swift
//  Movee
//
//  Created by user on 11/19/25.
//

import SwiftUI

private struct CoordinatorKey: EnvironmentKey {
    static let defaultValue: AppCoordinator? = nil
}

extension EnvironmentValues {
    var coordinator: AppCoordinator? {
        get { self[CoordinatorKey.self] }
        set { self[CoordinatorKey.self] = newValue }
    }
}
