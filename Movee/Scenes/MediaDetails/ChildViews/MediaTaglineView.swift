//
//  MediaTaglineView.swift
//  Movee
//
//  Created by user on 4/28/25.
//


import SwiftUI
import Combine

struct MediaTaglineView: View {
    var tagline: String?
    var isLoading: Bool = false
    
    var body: some View {
        Group {
            if let tagline, !tagline.isEmpty {
                Text(tagline)
            } else if isLoading {
                Text(verbatim: .placeholder(.medium))
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }.textStyle(.tagline)
    }
}