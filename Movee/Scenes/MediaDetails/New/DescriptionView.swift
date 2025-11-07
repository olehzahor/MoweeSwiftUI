//
//  DescriptionView.swift
//  Movee
//
//  Created by Oleh on 28.10.2025.
//

import SwiftUI

struct DescriptionView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    private let _text: String?
    
    var text: String {
        placeholder ? .placeholder(.multiline) : _text ?? ""
    }
    
    var body: some View {
        Text(text)
            .textStyle(.mediumText)
            .loadable()
            .failable()
    }
    
    init(text: String?) {
        self._text = text
    }
}
