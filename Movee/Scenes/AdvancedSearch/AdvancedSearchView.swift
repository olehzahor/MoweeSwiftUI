//
//  AdvancedSearchView.swift
//  Movee
//
//  Created by user on 5/7/25.
//

import SwiftUI


struct AdvancedSearchView: View {
    @Environment(\.coordinator) private var coordinator
    @StateObject var viewModel = AdvancedSearchViewModel()
    
    private let columns = [
      GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    @ViewBuilder
    private func createButtonView(_ item: AdvancedSearchViewModel.Item,
                                  section: AdvancedSearchViewModel.Section) -> some View {
        let isSelected = viewModel.isSelected(item, in: section)
        let isExcluded = viewModel.isExcluded(item, in: section)
        
        var title = isExcluded ? "-\(item.title)" : item.title
        
        let button = Button(title) {
            viewModel.selectItem(item, in: section)
        }
        
        if isSelected {
            button.buttonStyle(.borderedProminent)
        }
        else if isExcluded {
            button
                .buttonStyle(.borderedProminent)
                .tint(.red)
        } else {
            button.buttonStyle(.bordered)
        }
    }
        
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(viewModel.sections) { section in
                    Text(section.title)
                        .textStyle(.sectionTitle)
                    OverflowLayout(spacing: 8) {
                        ForEach(section.items, id: \.self) { item in
                            createButtonView(item, section: section)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                }
            }.padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Advanced search")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    coordinator?.push(.mediasList(viewModel.resultsSection))
                } label: {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}


#Preview {
    AdvancedSearchView()
}
