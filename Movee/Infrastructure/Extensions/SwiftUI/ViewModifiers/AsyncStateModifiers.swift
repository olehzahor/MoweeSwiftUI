//
//  AsyncStateModifiers.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

// MARK: - Protocols
protocol LoadableView: View {
    associatedtype LoadingContent: View
    @ViewBuilder func loadingView() -> LoadingContent
}

protocol FailableView: View {
    associatedtype ErrorContent: View
    @ViewBuilder func errorView(error: Error, retry: (() -> Void)?) -> ErrorContent
}

extension FailableView {
    @ViewBuilder func errorView(error: Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}

// MARK: - Unified View Modifier
struct AsyncStateModifier<LoadingContent: View, ErrorContent: View>: ViewModifier {
    let isLoading: Bool
    let error: Error?
    let retry: () -> Void
    let loadingContent: () -> LoadingContent
    let errorContent: (Error, @escaping () -> Void) -> ErrorContent

    private var state: State {
        if isLoading { return .loading }
        if let error { return .error(error.localizedDescription) }
        return .loaded
    }

    func body(content: Content) -> some View {
        ZStack {
            switch state {
            case .loading:
                loadingContent()
            case .error:
                if let error {
                    errorContent(error, retry)
                }
            case .loaded:
                content
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }

    private enum State: Equatable {
        case loading
        case error(String)
        case loaded
    }
}

// MARK: - View Extensions
extension View where Self: LoadableView {
    func loading(_ isLoading: Bool) -> some View {
        modifier(AsyncStateModifier(
            isLoading: isLoading,
            error: nil,
            retry: {},
            loadingContent: { self.loadingView() },
            errorContent: { _, _ in EmptyView() }
        ))
    }
}

extension View where Self: FailableView {
    func error(_ error: Error?, retry: @escaping () -> Void) -> some View {
        modifier(AsyncStateModifier(
            isLoading: false,
            error: error,
            retry: retry,
            loadingContent: { EmptyView() },
            errorContent: { error, retry in self.errorView(error: error, retry: retry) }
        ))
    }
}

extension View where Self: LoadableView & FailableView {
    func loading(_ isLoading: Bool, error: Error?, retry: @escaping () -> Void) -> some View {
        modifier(AsyncStateModifier(
            isLoading: isLoading,
            error: error,
            retry: retry,
            loadingContent: { self.loadingView() },
            errorContent: { error, retry in self.errorView(error: error, retry: retry) }
        ))
    }

    func loadingContext<Section>(_ context: AsyncLoadingContext<Section>, section: Section, retry: @escaping () -> Void) -> some View {
        self
            .loading(
                context[section].isAwaitingData,
                error: context[section].error,
                retry: retry)
            .hideWhen(context[section].isEmpty)
    }

    func loadingContext<Section, Reloader: FailedSectionsReloadable>(
        _ context: AsyncLoadingContext<Section>,
        section: Section,
        reloader: Reloader
    ) -> some View where Reloader.SectionType == Section {
        self
            .loading(context[section].isAwaitingData, error: context[section].error) {
                reloader.reloadFailedSections()
            }
            .hideWhen(context[section].isEmpty)
    }
}
