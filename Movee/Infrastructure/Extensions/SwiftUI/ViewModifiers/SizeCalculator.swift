//
//  SizeCalculator.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import SwiftUI
import Foundation

struct SizeCalculator: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGSize.self, of: { proxy in
                proxy.size
            }, action: { newSize in
                size = newSize
            })
    }
}

extension View {
    func saveSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeCalculator(size: size))
    }
}
