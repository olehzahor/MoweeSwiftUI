import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var overlayOpacity: Double = 0.5
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Color(.systemBackground)
                    .blendMode(.sourceAtop)
                    .opacity(overlayOpacity)
            )
            .compositingGroup()
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    overlayOpacity = 0
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}
