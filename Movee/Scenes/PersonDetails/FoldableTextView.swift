//
//  FoldableTextView.swift
//  Movee
//
//  Created by user on 4/19/25.
//


import SwiftUI
import Combine

struct FoldableTextView: View {
    @State var text: String
    @State var lineLimit: Int? = 5
    
    var onMoreTapped: (() -> Void)?
    
    @State private var isCollapsed = true
    
    @State private var fullSize: CGSize = .zero
    @State private var collapsedSize: CGSize = .zero
    @State private var buttonSize: CGSize = .zero
    private let buttonPadding: CGFloat = 36
    
    var body: some View {
        ZStack {
            if fullSize == .zero {
                Text(text)
                    .saveSize(in: $fullSize)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
            }
            Text(text)
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
        }
    }
}

#Preview {
    FoldableTextView(
        text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        lineLimit: 5
    )
}
