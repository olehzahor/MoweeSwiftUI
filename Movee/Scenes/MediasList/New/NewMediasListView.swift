//
//  NewMediasListView.swift
//  Movee
//
//  Created by Oleh on 03.11.2025.
//

import SwiftUI
import Combine

struct InfiniteList<Item: Identifiable, Content: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content
    let fetcher: () -> Void
    
//    @ViewBuilder
//    func loadingView() -> some View where Content: LoadableView {
//        content(items.first!).loadingView()
//    }
    
    var body: some View {
        List {
            ForEach(items) { item in
                content(item)
            }
            MediaRowView(data: .init(media: .placeholder))
                .redacted(reason: .placeholder)
                .shimmering()
                .listRowSeparator(.hidden)
                .onAppear {
                    fetcher()
                }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
//        .onAppear {
//            fetcher()
//        }
    }
}

extension InfiniteList: LoadableView where Content == MediaRowView {
    func loadingView() -> some View {
        if items.isEmpty {
            List(0..<20, id: \.self) { item in
                MediaRowView(data: .init(media: .placeholder))
                    .redacted(reason: .placeholder)
                    .shimmering()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        } else {
            self
//            List {
//                ForEach(items) { item in
//                    content(item)
//                }
//                MediaRowView(data: .placeholder)
//                    .redacted(reason: .placeholder)
//                    .shimmering()
//                    .listRowSeparator(.hidden)
//                    .onAppear {
//                        fetcher()
//                    }
//            }
//            .listStyle(.plain)
//            .scrollIndicators(.hidden)
        }
    }
}

extension InfiniteList: FailableView { }

struct NewMediasListView: View {
    var viewModel: NewMediasListViewModel

    private var title: String {
        viewModel.section.fullTitle ?? viewModel.section.title
    }
        
    var body: some View {
        NavigationStack {
            //Group {
//            InfiniteList(items: viewModel.items, content: { media in
//                MediaRowView(data: MediaUIModel(media: media))
//            }, fetcher: { Task { try await viewModel.fetch() } })
//            .loadingState(viewModel.loadingState, retry: {})
            
            List(viewModel.items) { item in
                MediaRowView(data: .init(media: item)).onFirstAppear {
                    if viewModel.isLastItem(item) {
                        Task { try await viewModel.fetch() }
                    }
                }
            }
            .onFirstAppear {
                Task { try await viewModel.fetch() }
            }
            //}
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(title == "Watchlist" ? .large : .inline)
        }
        .onChange(of: viewModel.loadingState) { oldValue, newValue in
            print(newValue)
        }
    }
    
    init(section: NewMediasSection) {
        viewModel = NewMediasListViewModel(section: section)
    }
}
//    private var medias: [Media] {
//        if !viewModel.items.isEmpty {
//            return viewModel.items
//        } else {
//            return Array(repeating: .placeholder, count: 10)
//        }
//    }
//
//    private func setupRowView(_ media: Media) -> AnyView {
//        var view: any View = MediaRowView(data: .init(media: media)).onAppear {
//            if viewModel.isLastItem(media) {
//                Task { try await viewModel.fetch() }
//            }
//        }
//
//        if media == .placeholder {
//            view = view.redacted(reason: .placeholder).shimmering()
//            return AnyView(view)
//        } else {
//            return AnyView(
//                NavigationLink {
//                    MediaDetailsView(media: media)
//                } label: {
//                    AnyView(view)
//                }
//            )
//        }
//    }

//                if viewModel.isLoaded, viewModel.medias.isEmpty,
//                   let placeholder = viewModel.section.placeholder {
//                    VStack(alignment: .center, spacing: 16) {
//                        Text(placeholder.title)
//                            .textStyle(.mediumTitle)
//                        if let subtitle = placeholder.subtitle {
//                            Text(subtitle)
//                                .textStyle(.mediumSubtitle)
//                        }
//                    }.padding(.horizontal)
//                } else {
//                    List(Array(medias.enumerated()), id: \.0) { _, media in
//                        ZStack {
//                            setupRowView(media)
//                        }
//                        .listRowSeparator(.hidden)
//                    }
//                    .listStyle(.plain)
//                    .scrollIndicators(.hidden)
//                    .onAppear {
//                        viewModel.fetchMedias()
//                    }
//                }
