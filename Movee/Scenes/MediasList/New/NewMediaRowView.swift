//
//  NewMediaRowView.swift
//  Movee
//
//  Created by Oleh on 06.11.2025.
//

import SwiftUI

struct NewMediaRowView: View {
    @Environment(\.placeholder) var placeholder: Bool
    
    private let _data: MediaUIModel
    
    var data: MediaUIModel {
        placeholder ? .placeholder : _data
    }
    
    @State var isExpanded: Bool = false
    
    private var subtitleLineLimit: Int? {
        isExpanded ? nil : 1
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MediaPosterView(data)
            VStack(alignment: .leading, spacing: 4) {
                if let title = data.title {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumTitle)
                }
                if let details = data.details {
                    Text(details)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                        .lineLimit(subtitleLineLimit)
                }
                if let overview = data.overview {
                    FoldableTextView(text: overview, lineLimit: nil) {
                        isExpanded = true
                    }
                    .textStyle(.mediumText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: isExpanded ? .infinity : nil,
            alignment: .topLeading
        )
        .loadable()
        .fallible()
    }
    
    init(data: MediaUIModel = .placeholder) {
        self._data = data
    }
}
