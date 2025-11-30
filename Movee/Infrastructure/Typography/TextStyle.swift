//
//  TextStyle.swift
//  Movee
//
//  Created by user on 4/15/25.
//

import SwiftUI

struct TextStyle {
    var font: Font
    var fontWeight: Font.Weight? = nil
    var textColor: Color? = .primary
    var italic: Bool = false
    var underline: Bool = false
    var underlineColor: Color? = nil
    var strikethrough: Bool = false
    var strikethroughColor: Color? = nil
    var kerning: CGFloat? = nil
    var lineSpacing: CGFloat? = nil
    
    var lineLimit: Int? = nil
    var multilineTextAlignment: TextAlignment? = nil
    // Optionally, add more properties like opacity or a TextShadow configuration
}

