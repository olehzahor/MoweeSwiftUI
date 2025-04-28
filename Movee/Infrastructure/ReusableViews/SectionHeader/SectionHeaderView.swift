//
//  SectionHeaderView.swift
//  Movee
//
//  Created by user on 4/27/25.
//

import SwiftUI

struct SectionHeaderView: View {
    var title: String
    var actionButton: String? = "See All"
    var isButtonHidden: Bool = false
    var action: (() -> AnyView)?
    
    var body: some View {
        HStack {
            Text(title)
                .textStyle(.sectionTitle)
            Spacer()
            if !isButtonHidden, let actionButton, let action {
                NavigationLink {
                    action()
                } label: {
                    Text(actionButton)
                }
            }
        }
    }
}
