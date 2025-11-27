//
//  Config.swift
//  Movee
//
//  Created by user on 11/27/25.
//

import Foundation

extension MediaPosterView {
    struct Config {
        let width: CGFloat
        let height: CGFloat
        let cornerRadius: CGFloat
        let showTitles: Bool

        init(
            width: CGFloat = 100,
            height: CGFloat = 150,
            cornerRadius: CGFloat = 8,
            showTitles: Bool = true
        ) {
            self.width = width
            self.height = height
            self.cornerRadius = cornerRadius
            self.showTitles = showTitles
        }

        static let `default` = Config()
        static let row = Config(showTitles: false)
        static let grid = Config(showTitles: true)
    }
}
