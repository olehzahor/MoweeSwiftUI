import SwiftUI

struct ShimmerModifier: ViewModifier {
    @State private var overlayOpacity: Double = 0.5

    func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .opacity(overlayOpacity)
//            .overlay(
//                Rectangle()
//                    .blendMode(.sourceAtop)
//                    .foregroundColor(Color(.systemBackground))
//                    .opacity(overlayOpacity)
//            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    overlayOpacity = 1//0.5
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerModifier())
    }
}
