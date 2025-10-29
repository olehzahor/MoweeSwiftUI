//
//  ScaledToFillAspectRatioModifier.swift
//  Movee
//
//  Created by Oleh on 29.10.2025.
//

import SwiftUI

struct ScaledToFillAspectRatioModifier: ViewModifier {
    let ratio: CGFloat
    let contentMode: ContentMode
    
    func body(content: Content) -> some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .aspectRatio(ratio, contentMode: contentMode)
            .overlay {
                content.scaledToFill()
            }
            .clipped()
    }
}

extension View {
    func scaledToFillAspectRatio(
        _ ratio: CGFloat,
        contentMode: ContentMode = .fill
    ) -> some View {
        modifier(ScaledToFillAspectRatioModifier(ratio: ratio, contentMode: contentMode))
    }
}
