//
//  SearchResultsView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel: SearchResultsViewModel

    private var query: String
    private var scope: SearchScope

    @ViewBuilder
    fileprivate func getRowView(for result: SearchResult.Result) -> some View {
        switch result {
        case .movie(let movie):
            MediaRowView(data: .init(media: Media(movie: movie)))
        case .tv(let tvShow):
            MediaRowView(data: .init(media: Media(tvShow: tvShow)))
        case .person(let person):
            PersonRowView(data: .init(MediaPerson(person: person)))
        }
    }
    
    var list: some View {
        InfiniteList(viewModel.dataSource) { result in
            Button {
                if let media = result.media {
                    coordinator?.push(.mediaDetails(media))
                } else if case .person(let person) = result.result {
                    coordinator?.push(.personDetails(.init(person: person)))
                }
            } label: {
                getRowView(for: result.result)
            }
        } placeholder: {
            MediaRowView()
                .loading(true)
        } emptyState: {
            ContentUnavailableView(.search)
        }
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .onChange(of: query) { _, newValue in
            viewModel.update(query: newValue, scope: scope)
        }
        .onChange(of: scope) { _, newValue in
            viewModel.update(query: query, scope: newValue)
        }
    }

    var body: some View {
        list
    }

    init(query: String, scope: SearchScope) {
        self.query = query
        self.scope = scope
        self.viewModel = SearchResultsViewModel(query: query, scope: scope)
    }
}

#Preview {
    SearchResultsView(query: "Avatar", scope: .all)
}
