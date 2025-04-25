//
//  TextStyleModifier.swift
//  Movee
//
//  Created by user on 4/15/25.
//

import SwiftUICore

struct TextStyleModifier: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        var modifiedContent: AnyView = AnyView(
            content
                .font(style.font)
                .foregroundColor(style.textColor)
        )
        if let fontWeight = style.fontWeight {
            modifiedContent = AnyView(modifiedContent.fontWeight(fontWeight))
        }

        if style.italic {
            modifiedContent = AnyView(modifiedContent.italic())
        }
        if let kerning = style.kerning {
            modifiedContent = AnyView(modifiedContent.kerning(kerning))
        }
        if let spacing = style.lineSpacing {
            modifiedContent = AnyView(modifiedContent.lineSpacing(spacing))
        }
        if style.underline {
            modifiedContent = AnyView(modifiedContent.underline(true, color: style.underlineColor))
        }
        if style.strikethrough {
            modifiedContent = AnyView(modifiedContent.strikethrough(true, color: style.strikethroughColor))
        }
        if let lineLimit = style.lineLimit {
            modifiedContent = AnyView(modifiedContent.lineLimit(lineLimit))
        }
        if let multilineTextAlignment = style.multilineTextAlignment {
            modifiedContent = AnyView(modifiedContent.multilineTextAlignment(multilineTextAlignment))
        }
        return modifiedContent
    }
}

extension View {
    /// Applies the given TextStyle to the view.
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}
