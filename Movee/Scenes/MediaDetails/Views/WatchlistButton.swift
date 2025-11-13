//
//  WatchlistButton.swift
//  Movee
//
//  Created by Oleh on 28.10.2025.
//

import SwiftUI

struct WatchlistButton: View {
    let isInWatchlist: Bool?
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            if let isInWatchlist = isInWatchlist {
                Image(systemName: isInWatchlist ? "bookmark.slash" : "bookmark")
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WatchlistButton(isInWatchlist: true) { }
        WatchlistButton(isInWatchlist: false) { }
        WatchlistButton(isInWatchlist: nil) { }
    }
    .padding()
}
