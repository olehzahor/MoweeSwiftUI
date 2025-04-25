//
//  MediaTrailerView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct MediaTrailerView: View {
    @State var size: CGSize = .zero
    
    var body: some View {
        Color(.green)
            .aspectRatio(16/9, contentMode: .fit)
            .cornerRadius(8)
            .overlay {
                VStack {
                    Text("⏵ Play Trailer")
                        .font(.title2)
                    Text("Sintel | first official trailer US (2010) 3D open movie project")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
    }
}
