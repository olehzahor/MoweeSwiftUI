//
//  NewMediaTaglineView.swift
//  Movee
//
//  Created by user on 4/28/25.
//

import SwiftUI

struct NewMediaTaglineView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    var tagline: String?

    var body: some View {
        if placeholder {
            Text(verbatim: .placeholder(.medium))
                .textStyle(.tagline)
        } else if let tagline, !tagline.isEmpty {
            Text(tagline)
                .textStyle(.tagline)
        }
    }
}
