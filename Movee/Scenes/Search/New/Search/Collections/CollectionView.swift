//
//  CollectionView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CollectionView: View {
    @Environment(\.coordinator) private var coordinator
    @State private var viewModel: CollectionViewModel
    
    private var titleDisplayMode: NavigationBarItem.TitleDisplayMode {
        coordinator?.path.isEmpty ?? false ? .automatic : .inline
    }
    
    var body: some View {
        ScrollView {
            CollectionGridView(viewModel.lists)
                .padding(.horizontal)
                .padding(.bottom)
                .onFirstAppear {
                    await viewModel.loader.fetchInitialData()
                }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(titleDisplayMode)
    }
    
    init(title: String, lists: [MediasList]) {
        viewModel = .init(title: title, lists: lists)
    }
    
    init() {
        viewModel = .init()
    }
}

#Preview {
    NavigationStack {
        CollectionView()
    }
}
