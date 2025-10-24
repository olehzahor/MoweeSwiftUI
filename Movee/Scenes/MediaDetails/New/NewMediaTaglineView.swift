//
//  NewMediaTaglineView.swift
//  Movee
//
//  Created by user on 4/28/25.
//

import SwiftUI

struct NewMediaTaglineView: View, LoadableView {
    var tagline: String?

    var body: some View {
        if let tagline, !tagline.isEmpty {
            Text(tagline)
                .textStyle(.tagline)
        }
    }

    func loadingView() -> some View {
        Text(verbatim: .placeholder(.medium))
            .redacted(reason: .placeholder)
            .shimmering()
            .textStyle(.tagline)
    }
}
