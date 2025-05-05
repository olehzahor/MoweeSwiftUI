//
//  MediaFactRowView.swift
//  Movee
//
//  Created by user on 4/25/25.
//

import SwiftUI
import Combine

struct MediaFactRowView: View {
    var fact: KeyValueItem<String>
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(fact.key)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.regular)
                Spacer()
                Text(fact.value)
                    .font(.headline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.trailing)
            }.padding(.vertical, 4)
            Divider()
        }
    }
}
