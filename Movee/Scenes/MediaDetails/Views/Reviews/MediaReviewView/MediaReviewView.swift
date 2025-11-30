//
//  MediaReviewView.swift
//  Movee
//
//  Created by user on 4/25/25.
//

import SwiftUI
import Combine

struct MediaReviewView: View {
    let data: Data

    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
            VStack(alignment: .leading) {
                Text(.init(data.content))
                    .textStyle(.smallText)
                Spacer()
                Divider().padding(.bottom, 8)
                HStack {
                    Text(data.ratingString)
                    Spacer()
                    Text(data.detailsString)
                }.foregroundStyle(.secondary)
                .textStyle(.smallText)
            }.padding()
        }
        .clipShape(.rect(cornerRadius: 8))
        .tint(.secondary)
    }
}
