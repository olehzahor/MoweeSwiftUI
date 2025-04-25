import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var overlayOpacity: Double = 0.0

    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .foregroundColor(Color(.systemBackground))
                    .opacity(overlayOpacity)
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    overlayOpacity = 0.5
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}
