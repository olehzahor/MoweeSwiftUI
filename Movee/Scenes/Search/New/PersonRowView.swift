//
//  PersonRowView.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import SwiftUI

struct PersonRowView: View {
    let person: MediaPerson

    private var knownForMovies: [PersonCredit] {
        Array((person.knownFor ?? []).prefix(3))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImageView(
                url: person.profilePictureURL,
                width: 100, height: 150,
                cornerRadius: 8,
                placeholder: person.placeholderImage)

            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .textStyle(.mediumTitle)

                if let department = person.department {
                    Text(department)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                }
                
                Spacer()

                if !knownForMovies.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(knownForMovies, id: \.self) { credit in
                            AsyncImageView(
                                url: credit.media.posterURL,
                                width: 65, height: 90,
                                cornerRadius: 8,
                                placeholder: .imageMoviePlaceholder)
                        }
                    }
                    .padding(.top, 4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        //.frame(height: 150)
    }
}
