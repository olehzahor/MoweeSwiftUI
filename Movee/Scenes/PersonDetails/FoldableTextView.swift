//
//  FoldableTextView.swift
//  Movee
//
//  Created by user on 4/19/25.
//


import SwiftUI
import Combine

struct FoldableTextView: View {
    @Environment(\.isPlaceholder) private var isPlaceholder: Bool
    
    @State var text: String
    @State var lineLimit: Int? = 5
    
    var onMoreTapped: (() -> Void)?
    
    @State private var isCollapsed = true
    
    @State private var fullSize: CGSize = .zero
    @State private var collapsedSize: CGSize = .zero
    @State private var buttonSize: CGSize = .zero
    private let buttonPadding: CGFloat = 36
    
    private var displayText: String {
        isPlaceholder ? .placeholder(.multiline) : text
    }
    
    var body: some View {
        ZStack {
            if fullSize == .zero {
                Text(displayText)
                    .saveSize(in: $fullSize)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
            }
            Text(displayText)
                .lineLimit(isCollapsed ? lineLimit : nil)
                .overlay(alignment: .bottomTrailing) {
                    if collapsedSize.height < fullSize.height {
                        Button("more") {
                            isCollapsed = false
                            onMoreTapped?()
                        }
                        .fontWeight(.semibold)
                        .padding(.leading, buttonPadding)
                        .saveSize(in: $buttonSize)
                        .buttonStyle(.plain)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color(uiColor: .systemBackground)
                                ]),
                                startPoint: .leading,
                                endPoint: .init(x: buttonPadding / buttonSize.width, y: 0.5)
                            )
                        )
                    }
                }.saveSize(in: $collapsedSize)
                .transition(.identity)
        }
    }
}

extension FoldableTextView: LoadableView, FailableView {
    func loadingView() -> some View {
        Self(text: .placeholder(.multiline))
            .redacted(reason: .placeholder)
            .shimmering()
    }
}

#Preview {
    FoldableTextView(
        text: .placeholder(.multiline),
        lineLimit: 5
    )
}
