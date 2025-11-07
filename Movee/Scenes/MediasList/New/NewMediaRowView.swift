//
//  NewMediaRowView.swift
//  Movee
//
//  Created by Oleh on 06.11.2025.
//

import SwiftUI

private struct CarouselPaddingEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat = 20.0
}

extension EnvironmentValues {
    var carouselPadding: CGFloat {
        get { self[CarouselPaddingEnvironmentKey.self] }
        set { self[CarouselPaddingEnvironmentKey.self] = newValue }
    }
}

extension View {
    func carouselPadding(_ value: CGFloat) -> some View {
        self.environment(\.carouselPadding, value)
    }
}


private struct PlaceholderEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var placeholder: Bool {
        get { self[PlaceholderEnvironmentKey.self] }
        set { self[PlaceholderEnvironmentKey.self] = newValue }
    }
}

extension View {
    func placeholder() -> some View {
        self.environment(\.placeholder, true)
        //self.modifier(LoadingModifier(isLoading: isLoading))
    }
}

private struct IsLoadingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingEnvironmentKey.self] }
        set { self[IsLoadingEnvironmentKey.self] = newValue }
    }
}

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

//struct LoadingModifier: ViewModifier {
//    let isLoading: Bool
//
//    func body(content: Content) -> some View {
//        ZStack {
//            if isLoading {
//                content
//                    .redacted(reason: .placeholder)
//                    .shimmering()
//            } else {
//                content
//            }
//        }
//        .environment(\.isPlaceholder, isLoading)
//        .animation(.easeInOut(duration: 0.3), value: isLoading)
//    }
//}

struct LoadableModifier: ViewModifier {
    @Environment(\.isLoading) private var isLoading: Bool
    
    func body(content: Content) -> some View {
        if isLoading {
            content
                .redacted(reason: .placeholder)
                .shimmering()
        } else {
            content
        }
    }
}

struct FailableModifier<FailedContent: View>: ViewModifier {
    @Environment(\.errorConfig) private var config: ErrorConfiguration?
    let failedView: (Error, (() -> Void)?) -> FailedContent
    
    func body(content: Content) -> some View {
        if let error = config?.error {
            failedView(error, config?.retry)
        } else {
            content
        }
    }
    
    init(_ failedView: @escaping (Error, (() -> Void)?) -> FailedContent = {
        ErrorRetryView(error: $0, retry: $1)
    }) {
        self.failedView = failedView
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        self
            .environment(\.placeholder, isLoading)
            .environment(\.isLoading, isLoading)
    }
    
    func loadable() -> some View {
        self.modifier(LoadableModifier())
    }
    
    func failable() -> some View {
        self.modifier(FailableModifier())
    }
    
    func error(_ error: Error?, retry: (() -> Void)? = nil) -> some View {
        self.environment(\.errorConfig, .init(error: error, retry: retry))
    }
    
    func loadingState(_ state: AsyncLoadingState, hideWhenEmpty: Bool = true, retry: (() -> Void)? = nil) -> some View {
        self
            .loading(state.isAwaitingData)
            .error(state.error, retry: retry)
            .hideWhen(hideWhenEmpty ? state.isEmpty : false)
    }
    
    func loadingState<Fetcher: SectionFetchable&FailedSectionsReloadable, Section>(_ fetcher: Fetcher, section: Section, hideWhenEmpty: Bool = true) -> some View where Section == Fetcher.SectionType {
        let state = fetcher.sectionsContext[section]
        return self
            .loading(state.isAwaitingData)
            .error(state.error, retry: { fetcher.reloadFailedSections() })
            .hideWhen(hideWhenEmpty ? state.isEmpty : false)
    }
}

struct NewMediaRowView: View {
    @Environment(\.isLoading) var isLoading: Bool
    
    private let _data: MediaUIModel
    
    var data: MediaUIModel {
        isLoading ? .placeholder : _data
    }
    
    @State var isExpanded: Bool = false
    @State private var posterSize: CGSize = .zero
    
    private var maxHeight: CGFloat? {
        isExpanded ? nil : 150
    }
    
    private var subtitleLineLimit: Int? {
        isExpanded ? nil : 1
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // TODO: add styling (hide titles when needed)
            MediaPosterView(.init(posterURL: data.posterURL, placeholder: data.placeholder, rating: data.rating))
                .saveSize(in: $posterSize)
            VStack(alignment: .leading, spacing: 4) {
                if let title = data.title {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumTitle)
                }
                if let details = data.details {
                    Text(details)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                        .lineLimit(subtitleLineLimit)
                }
                if let overview = data.overview {
                    FoldableTextView(text: overview, lineLimit: nil) {
                        isExpanded = true
                    }
                    .textStyle(.mediumText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: maxHeight)
        .loadable()
        .failable()
    }
    
    init(data: MediaUIModel = .placeholder) {
        self._data = data
    }
}
