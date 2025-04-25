//
//  TextStlyle+Styles.swift
//  Movee
//
//  Created by user on 4/15/25.
//

extension TextStyle {
    static let mediaLargeTitle = TextStyle(
        font: .title,
        fontWeight: .ultraLight,
        multilineTextAlignment: .center
    )
    
    static let mediaSmallTitle = TextStyle(
        font: .footnote,
        fontWeight: .semibold,
        lineLimit: 3,
        multilineTextAlignment: .center
    )
    
    static let sectionTitle = TextStyle(
        font: .title3,
        fontWeight: .semibold
    )
    
    static let tagline = TextStyle(
        font: .subheadline,
        fontWeight: .semibold,
        italic: true
    )
    
    static let smallText = TextStyle(
        font: .footnote
    )
    
    static let mediumText = TextStyle(
        font: .subheadline
    )
    
    static let largeText = TextStyle(
        font: .body
    )
    
    static let smallTitle = TextStyle(
        font: .subheadline,
        fontWeight: .semibold,
        multilineTextAlignment: .center
    )
    
    static let smallSubtitle = TextStyle(
        font: .caption,
        textColor: .secondary,
        multilineTextAlignment: .center
    )

    static let mediumTitle = TextStyle(
        font: .headline,
        multilineTextAlignment: .center
    )
    
    static let mediumSubtitle = TextStyle(
        font: .subheadline,
        textColor: .secondary,
        multilineTextAlignment: .center
    )
}
