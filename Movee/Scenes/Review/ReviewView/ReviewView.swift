//
//  ReviewView.swift
//  Movee
//
//  Created by user on 4/13/25.
//

import SwiftUI
import Factory

struct ReviewView: View {
    let data: Data

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    AsyncImageView(
                        url: data.authorAvatarURL,
                        placeholder: .init(resource: .imageMalePersonPlaceholder)
                    )
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text("\(data.authorString)")
                            .textStyle(.mediumTitle)
                        if let createdAt = data.createdAtAbsoluteString {
                            Text(createdAt)
                                .textStyle(.mediumSubtitle)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(.init(data.content))
            }.padding()
        }
    }
}
