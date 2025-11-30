//
//  PersonRowView.swift
//  Movee
//
//  Created by user on 11/20/25.
//

import SwiftUI

struct PersonRowView: View {
    let data: Data
    
    private var knownFor: [Data.Media] {
        Array((data.knownFor).prefix(3))
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if knownFor.isEmpty {
                PersonCompactView(data: .init(pictureURL: data.pictureURL,
                                              placeholder: data.picturePlaceholder)
                )
            } else {
                MediaPosterView(
                    data: .init(posterURL: data.pictureURL,
                                placeholder: data.picturePlaceholder),
                    config: .row
                )
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(data.name)
                    .textStyle(.mediumTitle)

                if let department = data.department {
                    Text(department)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                }
                
                if !knownFor.isEmpty {
                    Spacer()
                }

                if !knownFor.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(knownFor, id: \.self) { media in
                            MediaPosterView(
                                data: .init(posterURL: media.posterURL,
                                            placeholder: .imageMoviePlaceholder),
                                config: .init(width: 60, height: 90, cornerRadius: 6)
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    List {
        PersonRowView(data: .init(.mock))
        PersonRowView(data: .init(.mockWithoutMedia))
    }.listStyle(.plain)
}
