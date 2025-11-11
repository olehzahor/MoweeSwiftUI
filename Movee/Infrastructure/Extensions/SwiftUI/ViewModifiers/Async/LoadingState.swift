//
//  LoadingState.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

extension View {
    func loadingState(_ state: AsyncLoadingState, hideWhenEmpty: Bool = true, retry: (() -> Void)? = nil) -> some View {
        self
            .loading(state.isAwaitingData)
            .error(state.error, retry: retry)
            .hidden(hideWhenEmpty ? state.isEmpty : false)
    }
    
    func loadingState<Fetcher: SectionFetchable&FailedSectionsReloadable, Section>(_ fetcher: Fetcher, section: Section, hideWhenEmpty: Bool = true) -> some View where Section == Fetcher.SectionType {
        let state = fetcher.sectionsContext[section]
        return self
            .loading(state.isAwaitingData)
            .error(state.error, retry: { fetcher.reloadFailedSections() })
            .hidden(hideWhenEmpty ? state.isEmpty : false)
    }
}
