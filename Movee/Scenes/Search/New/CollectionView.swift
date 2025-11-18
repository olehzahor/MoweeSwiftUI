//
//  CollectionView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CollectionView: View {
    @State private var viewModel: CollectionViewModel
    
    var body: some View {
        ScrollView {
            CollectionGridView(viewModel.lists)
                .padding(.horizontal)
                .padding(.bottom)
                .onFirstAppear {
                    viewModel.fetchInitialData()
                }
        }
        .scrollIndicators(.hidden)
        .navigationTitle(viewModel.title)
        //.navigationBarTitleDisplayMode(.automatic)
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
