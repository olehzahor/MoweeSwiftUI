//
//  PersonCompactView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct PersonCompactView: View {
    let data: Data

    var body: some View {
        VStack {
            AsyncImageView(
                url: data.pictureURL,
                placeholder: data.placeholder
            )
            .frame(width: 100, height: 100)
            .clipShape(Circle())

            if let name = data.name {
                Text(name)
                    .textStyle(.smallTitle)
            }
            if let role = data.role {
                Text(role)
                    .textStyle(.smallSubtitle)
            }
            Spacer()
        }
        .frame(maxHeight: 185)
        .frame(width: 100)
    }
}

#Preview {
    PersonCompactView(
        data: .init(.mock)
    )
}
