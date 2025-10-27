//
//  SectionView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI

struct SectionView<Content: View>: View {
    let header: SectionHeaderData
    @ViewBuilder let content: () -> Content
        
    @ViewBuilder
    func sectionContainer(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(data: header)
            content()
        }
    }

    var body: some View {
        sectionContainer(content: content)
    }
}

extension SectionView: LoadableView where Content: LoadableView {
    func loadingView() -> some View {
        sectionContainer {
            content().loadingView()
        }
    }
}

extension SectionView: FailableView where Content: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        sectionContainer {
            content().errorView(error: error, retry: retry)
        }
    }
}

