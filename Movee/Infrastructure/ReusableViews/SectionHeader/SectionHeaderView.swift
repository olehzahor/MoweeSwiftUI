//
//  SectionHeaderView.swift
//  Movee
//
//  Created by user on 4/27/25.
//

import SwiftUI

struct SectionHeaderData {
    typealias ActionClosure = (AppCoordinator?) -> Void
    
    let title: String
    let actionButton: String?
    let isButtonHidden: Bool
    let action: ActionClosure?
    
    init(title: String, actionButton: String? = "See All", isButtonHidden: Bool = false, action: ActionClosure? = nil) {
        self.title = title
        self.actionButton = actionButton
        self.isButtonHidden = isButtonHidden
        self.action = action
    }
}

struct SectionHeaderView: View {
    @Environment(\.coordinator) private var coordinator
    
    let data: SectionHeaderData
     
    var body: some View {
        HStack {
            Text(data.title)
                .textStyle(.sectionTitle)
            Spacer()
            if !data.isButtonHidden,
               let actionButton = data.actionButton,
               let action = data.action {
                Button {
                    action(coordinator)
                } label: {
                    Text(actionButton)
                }
            }
        }
    }
}

extension SectionHeaderView {
    init(title: String,
         actionButton: String? = "See All",
         isButtonHidden: Bool = false,
         action: SectionHeaderData.ActionClosure? = nil) {
        self.data = .init(
            title: title,
            actionButton: actionButton,
            isButtonHidden: isButtonHidden,
            action: action
        )
    }
}
