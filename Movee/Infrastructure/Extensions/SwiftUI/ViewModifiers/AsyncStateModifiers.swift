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

// MARK: - View Modifiers
struct LoadingModifier<LoadingContent: View>: ViewModifier {
    let isLoading: Bool
    let loadingContent: () -> LoadingContent

    func body(content: Content) -> some View {
        if isLoading {
            loadingContent()
        } else {
            content
        }
    }
}

struct ErrorModifier<ErrorContent: View>: ViewModifier {
    let error: Error?
    let retry: () -> Void
    let errorContent: (Error) -> ErrorContent

    func body(content: Content) -> some View {
        if let error {
            errorContent(error)
        } else {
            content
        }
    }
}

// MARK: - Loading State
private enum LoadingState: Equatable {
    case loading
    case error(String)
    case loaded

    static func == (lhs: LoadingState, rhs: LoadingState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.loaded, .loaded):
            return true
        case (.error(let lhsMsg), .error(let rhsMsg)):
            return lhsMsg == rhsMsg
        default:
            return false
        }
    }
}

// MARK: - View Extensions
extension View where Self: LoadableView {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading) {
            self.loadingView()
        })
    }
}

extension View where Self: FailableView {
    func error(_ error: Error?, retry: @escaping () -> Void) -> some View
{
        modifier(ErrorModifier(error: error, retry: retry) { error in
            self.errorView(error: error, retry: retry)
        })
    }
}

extension View where Self: LoadableView & FailableView {
    func loading(_ isLoading: Bool, error: Error?, retry: @escaping () -> Void) -> some View {
        let state: LoadingState = {
            if isLoading { return .loading }
            if let error { return .error(error.localizedDescription) }
            return .loaded
        }()

        return ZStack {
            switch state {
            case .loading:
                loadingView()
            case .error:
                if let error {
                    errorView(error: error, retry: retry)
                }
            case .loaded:
                self
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }

    func loadingContext<Section>(_ context: AsyncLoadingContext<Section>, section: Section, retry: @escaping () -> Void) -> some View {
        self
            .loading(context[section].isLoading, error: context[section].error, retry: retry)
            .hideWhen(context[section].isEmpty)
    }

    func loadingContext<Section, Fetcher: SectionFetchable>(
        _ context: AsyncLoadingContext<Section>,
        section: Section,
        fetcher: Fetcher
    ) -> some View where Fetcher.SectionType == Section {
        self
            .loading(context[section].isLoading, error: context[section].error) {
                fetcher.fetch(section)
            }
            .hideWhen(context[section].isEmpty)
    }
}
