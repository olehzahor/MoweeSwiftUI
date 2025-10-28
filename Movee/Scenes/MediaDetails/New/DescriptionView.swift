//
//  DescriptionView.swift
//  Movee
//
//  Created by Oleh on 28.10.2025.
//

import SwiftUI

struct DescriptionView: View {
    let text: String?
    
    var body: some View {
        Text(text ?? "")
            .textStyle(.mediumText)
    }
}

extension DescriptionView: LoadableView {
    func loadingView() -> some View {
        Self(
            text: .placeholder(.multiline)
        )
        .redacted(reason: .placeholder)
        .shimmering()
    }
}

extension DescriptionView: FailableView { }
