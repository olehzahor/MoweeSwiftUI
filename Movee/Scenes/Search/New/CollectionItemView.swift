//
//  CollectionItemView.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import SwiftUI

struct CollectionItemView: View {
    let item: Data
    
    var body: some View {
        Text(item.name)
            .textStyle(.smallTitle)
            .multilineTextAlignment(.center)
            .padding()
            .frame(minHeight: 60)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background {
                Color(UIColor.secondarySystemBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

extension CollectionItemView {
    struct Data {
        let name: String
        
        init(_ data: CollectionGridView.Data) {
            self.name = data.name
        }
        
        init(name: String) {
            self.name = name
        }
    }
}
