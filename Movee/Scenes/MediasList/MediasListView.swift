//
//  MediasListView.swift
//  Movee
//
//  Created by user on 4/7/25.
//

import SwiftUI
import Combine


/*
 struct NewMediasListView: View {
     @StateObject var viewModel: NewMediasListViewModel

     private var title: String {
         viewModel.section.fullTitle ?? viewModel.section.title
     }
     
     private var medias: [Media] {
         if !viewModel.medias.isEmpty {
             return viewModel.medias
         } else {
             return Array(repeating: .placeholder, count: 10)
         }
     }
     
     private func setupRowView(_ media: Media) -> AnyView {
         var view: any View = MediaRowView(data: .init(media: media)).onAppear {
             if viewModel.isLastLoaded(media: media) {
                 viewModel.fetchMedias()
             }
         }
         
         if media == .placeholder {
             view = view.redacted(reason: .placeholder).shimmering()
             return AnyView(view)
         } else {
             return AnyView(
                 NavigationLink {
                     MediaDetailsView(media: media)
                 } label: {
                     AnyView(view)
                 }
             )
         }
     }
     
     var body: some View {
         NavigationStack {
             Group {
                 if viewModel.isLoaded, viewModel.medias.isEmpty,
                    let placeholder = viewModel.section.placeholder {
                     VStack(alignment: .center, spacing: 16) {
                         Text(placeholder.title)
                             .textStyle(.mediumTitle)
                         if let subtitle = placeholder.subtitle {
                             Text(subtitle)
                                 .textStyle(.mediumSubtitle)
                         }
                     }.padding(.horizontal)
                 } else {
                     List(Array(medias.enumerated()), id: \.0) { _, media in
                         ZStack {
                             setupRowView(media)
                         }
                         .listRowSeparator(.hidden)
                     }
                     .listStyle(.plain)
                     .scrollIndicators(.hidden)
                     .onAppear {
                         viewModel.fetchMedias()
                     }
                 }
             }
             .navigationTitle(title)
             .navigationBarTitleDisplayMode(title == "Watchlist" ? .large : .inline)
         }
     }
     
     init(section: NewMediasSection) {
         _viewModel = StateObject(wrappedValue: NewMediasListViewModel(section: section))
     }
 }

 */

struct MediasListView: View {
    @StateObject var viewModel: MediasListViewModel

    private var title: String {
        viewModel.section.fullTitle ?? viewModel.section.title
    }
    
    private var medias: [Media] {
        if !viewModel.medias.isEmpty {
            return viewModel.medias
        } else {
            return Array(repeating: .placeholder, count: 10)
        }
    }
    
    private func setupRowView(_ media: Media) -> AnyView {
        var view: any View = MediaRowView(data: .init(media: media)).onAppear {
            if viewModel.isLastLoaded(media: media) {
                viewModel.fetchMedias()
            }
        }
        
        if media == .placeholder {
            view = view.redacted(reason: .placeholder).shimmering()
            return AnyView(view)
        } else {
            return AnyView(
                NavigationLink {
                    NewMediaDetailsView(media: media)
                } label: {
                    AnyView(view)
                }
            )
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoaded, viewModel.medias.isEmpty,
                   let placeholder = viewModel.section.placeholder {
                    VStack(alignment: .center, spacing: 16) {
                        Text(placeholder.title)
                            .textStyle(.mediumTitle)
                        if let subtitle = placeholder.subtitle {
                            Text(subtitle)
                                .textStyle(.mediumSubtitle)
                        }
                    }.padding(.horizontal)
                } else {
                    List(Array(medias.enumerated()), id: \.0) { _, media in
                        ZStack {
                            setupRowView(media)
                        }
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        viewModel.fetchMedias()
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(title == "Watchlist" ? .large : .inline)
        }
    }
    
    init(section: MediasSection) {
        _viewModel = StateObject(wrappedValue: MediasListViewModel(section: section))
    }
}

#Preview {
    MediasListView(section: [MediasSection].homePageSections.first!)
}
