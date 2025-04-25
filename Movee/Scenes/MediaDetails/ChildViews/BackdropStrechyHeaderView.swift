//
//  BackdropStrechyHeaderView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct BackdropStrechyHeaderView: View {
    var backdropURL: URL?
    
    var body: some View {
        GeometryReader { geometry in
            let minY = geometry.frame(in: .global).minY
            let calculatedHeight = geometry.size.height + (minY > 0 ? minY : 0)
            
            ZStack {
                AsyncImageView(url: backdropURL)
                
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: 0.0),
                        .init(color: .clear, location: 0.7),
                        .init(color: Color(.systemBackground), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: geometry.size.width, height: calculatedHeight)
            .offset(y: (minY > 0 ? -minY : 0))
        }
        .frame(height: 300)
    }
}
