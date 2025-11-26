//
//  PersonMediumView.swift
//  Movee
//
//  Created by user on 4/17/25.
//

import SwiftUI

struct PersonMediumView: View {
    let data: Data

    var body: some View {
        VStack(alignment: .center) {
            AsyncImageView(
                url: data.profilePictureURL,
                placeholder: data.placeholderImage
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(2/3, contentMode: .fit)
            Text(data.name)
                .textStyle(.smallTitle)
            if let role = data.role {
                Text(role)
                    .textStyle(.smallSubtitle)
            }
        }
    }
}

#Preview {
    PersonMediumView(
        data: .init(.mock)
    )
}
