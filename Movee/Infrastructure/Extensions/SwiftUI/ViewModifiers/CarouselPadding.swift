//
//  CarouselPaddings.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import SwiftUI

private struct CarouselPaddingEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat = 20.0
}

extension EnvironmentValues {
    var carouselPadding: CGFloat {
        get { self[CarouselPaddingEnvironmentKey.self] }
        set { self[CarouselPaddingEnvironmentKey.self] = newValue }
    }
}

extension View {
    func carouselPadding(_ value: CGFloat) -> some View {
        self.environment(\.carouselPadding, value)
    }
}
