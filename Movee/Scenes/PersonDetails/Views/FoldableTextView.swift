//
//  FoldableTextView.swift
//  Movee
//
//  Created by user on 4/19/25.
//


import SwiftUI
import Combine

struct FoldableTextView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    let text: String
    let lineLimit: Int?
    
    let onMoreTapped: (() -> Void)?
    
    @State private var isCollapsed = true
    
    @State private var fullSize: CGSize = .zero
    @State private var collapsedSize: CGSize = .zero
    @State private var buttonSize: CGSize = .zero
    private let buttonPadding: CGFloat = 36
    
    private var displayText: String {
        placeholder ? .placeholder(.multiline) : text
    }
    
    private var moreButtonIsHidden: Bool {
        collapsedSize.height >= fullSize.height
    }
        
    @ViewBuilder
    private var moreButton: some View {
        Button("more") {
            isCollapsed = false
            onMoreTapped?()
        }
        .fontWeight(.semibold)
        .padding(.leading, buttonPadding)
        .saveSize(in: $buttonSize)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var measurementText: some View {
        Text(displayText)
            .saveSize(in: $fullSize)
            .foregroundStyle(.red)
            .fixedSize(horizontal: false, vertical: true)
            .hidden()
    }
    
    @ViewBuilder
    private var mask: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color(uiColor: .systemBackground)
            ]),
            startPoint: .leading,
            endPoint: .init(x: buttonPadding / buttonSize.width, y: 0.5)
        )
        .frame(width: buttonSize.width, height: buttonSize.height)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text(displayText)
                .lineLimit(isCollapsed ? lineLimit : nil)
                .saveSize(in: $collapsedSize)
                .loadable()
                .fallible()

            mask.blendMode(.destinationOut)
        }
        .compositingGroup()
        .overlay(alignment: .bottomTrailing) {
            moreButton
                .hidden(moreButtonIsHidden)
        }
        .background {
            measurementText
        }
    }
    
    init(text: String, lineLimit: Int? = 5, onMoreTapped: (() -> Void)? = nil) {
        self.text = text
        self.lineLimit = lineLimit
        self.onMoreTapped = onMoreTapped
    }
}
