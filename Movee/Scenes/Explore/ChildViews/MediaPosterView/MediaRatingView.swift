//
//  MediaRatingView.swift
//  Movee
//
//  Created by user on 4/30/25.
//


import SwiftUI
import Combine

struct MediaRatingView: View {
    var rating: Double
    
    private var backgroundColor: Color {
        if rating >= 7.0 {
            return .green
        } else if rating >= 5.0 {
            return .yellow
        } else {
            return .red
        }
    }

    var body: some View {
        Text(String(format: "%.1f", rating))
            .font(.system(size: 8))
            .foregroundStyle(.black)
            .padding(.horizontal, 4)
            .background(backgroundColor.opacity(0.8))
            .clipShape(.capsule)
    }
}