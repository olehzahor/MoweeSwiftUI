//
//  NewMediaRowView.swift
//  Movee
//
//  Created by Oleh on 06.11.2025.
//

import SwiftUI

private struct IsLoadingEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isLoading: Bool {
        get { self[IsLoadingEnvironmentKey.self] }
        set { self[IsLoadingEnvironmentKey.self] = newValue }
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

extension View {
    func setLoading(_ isLoading: Bool) -> some View {
        self.environment(\.isLoading, isLoading)
        //self.modifier(LoadingModifier(isLoading: isLoading))
    }
    
    func loadable() -> some View {
        self.modifier(LoadableModifier())
        //self.modifier(LoadingModifier(isLoading: isLoading))
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
        }.frame(maxHeight: maxHeight)
    }
    
    init(data: MediaUIModel = .placeholder) {
        self._data = data
    }
}
