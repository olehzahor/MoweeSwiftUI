//
//  Error.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

struct ErrorConfiguration {
    let error: Error?
    let retry: (() -> Void)?
}

private struct ErrorConfigurationEnvironmentKey: EnvironmentKey {
    static let defaultValue: ErrorConfiguration? = nil
}

extension EnvironmentValues {
    var errorConfig: ErrorConfiguration? {
        get { self[ErrorConfigurationEnvironmentKey.self] }
        set { self[ErrorConfigurationEnvironmentKey.self] = newValue }
    }
}

extension View {
    func error(_ error: Error?, retry: (() -> Void)? = nil) -> some View {
        self.environment(\.errorConfig, .init(error: error, retry: retry))
    }
}
