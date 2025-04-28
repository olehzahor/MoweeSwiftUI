//
//  ReviewView.swift
//  Movee
//
//  Created by user on 4/13/25.
//

import SwiftUI

struct ReviewView: View {
    let mediaTitle: String
    let review: Review
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                //Text(mediaTitle).font(.title).fontWeight(.semibold)
                
                HStack(spacing: 16) {
                    AsyncImageView(url: review.authorAvatarURL, width: 50, height: 50, cornerRadius: 25, placeholder: .init(resource: .imageMalePersonPlaceholder))
                    VStack(alignment: .leading) {
                        Text("\(review.authorString)")
                            .textStyle(.mediumTitle)
                        Text("\(review.createdAtAbsoluteString)")
                            .textStyle(.mediumSubtitle)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(.init(review.content))
            }.padding()
        }
    }
}

//#Preview {
//    ReviewView()
//}
