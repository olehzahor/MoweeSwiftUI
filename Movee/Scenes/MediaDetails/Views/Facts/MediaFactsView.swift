//
//  MediaFactsView.swift
//  Movee
//
//  Created by user on 4/25/25.
//

import SwiftUI
import Combine

struct MediaFactsView: View {
    var facts: [KeyValueItem<String>]
    
    var body: some View {
        VStack {
            ForEach(facts) { fact in
                MediaFactRowView(fact: fact)
            }
        }
    }
}
