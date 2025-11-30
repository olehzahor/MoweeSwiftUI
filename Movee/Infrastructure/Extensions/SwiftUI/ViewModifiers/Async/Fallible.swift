//
//  Failable.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

struct FallibleModifier<FailedContent: View>: ViewModifier {
    @Environment(\.errorConfig) private var config: ErrorConfiguration?
    let failedView: (Error, (() -> Void)?) -> FailedContent

    func body(content: Content) -> some View {
        if let error = config?.error {
            failedView(error, config?.retry)
        } else {
            content
        }
    }

    init(_ failedView: @escaping (Error, (() -> Void)?) -> FailedContent) {
        self.failedView = failedView
    }
}

extension View {
    func fallible<FailedContent: View>(
        @ViewBuilder _ failedView: @escaping (Error, (() -> Void)?) -> FailedContent = { error, retry in
            ErrorRetryView(error: error, retry: retry)
        }
    ) -> some View {
        self.modifier(FallibleModifier(failedView))
    }
}
