//
//  NewMediaReviewsSectionView.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import SwiftUI

struct SectionView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    
    @ViewBuilder
    func sectionContainer(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: "Reviews",
                isButtonHidden: true) {
                    AnyView(EmptyView())
                }
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

struct NewMediaReviewsSectionView: View {
    var reviews: [Review]?
    var horizontalPadding: CGFloat

    @ViewBuilder
    private func sectionContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(
                title: "Reviews",
                isButtonHidden: true) {
                    AnyView(EmptyView())
                }
            content()
        }
    }

    var body: some View {
        sectionContainer {
            NewMediaReviewsCarouselView(
                reviews: reviews ?? [],
                horizontalPadding: horizontalPadding
            )
        }
    }

    init(
        reviews: [Review]?,
        horizontalPadding: CGFloat = 20
    ) {
        self.reviews = reviews
        self.horizontalPadding = horizontalPadding
    }
}

// MARK: - Loadable conformance
extension NewMediaReviewsSectionView: LoadableView {
    func loadingView() -> some View {
        sectionContainer {
            NewMediaReviewsCarouselView(
                reviews: [.placeholder, .placeholder],
                horizontalPadding: horizontalPadding
            )
            .redacted(reason: .placeholder)
            .shimmering()
        }
    }
}

// MARK: - Failable conformance
extension NewMediaReviewsSectionView: FailableView {
    func errorView(error: any Error, retry: (() -> Void)?) -> some View {
        ErrorRetryView(error: error, retry: retry)
    }
}
