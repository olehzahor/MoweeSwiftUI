//
//  AsyncButton.swift
//  Movee
//
//  Created by user on 11/22/25.
//

import SwiftUI

struct AsyncButton<Label: View>: View {
    let action: () async -> Void
    let disableOnLoading: Bool
    @ViewBuilder let label: (Bool) -> Label
    
    @State private var triggerID = 0
    @State private var isLoading = false
    
    init(
        disableOnLoading: Bool = true,
        action: @escaping () async -> Void,
        @ViewBuilder label: @escaping (Bool) -> Label
    ) {
        self.action = action
        self.disableOnLoading = disableOnLoading
        self.label = label
    }
    
    var body: some View {
        Button {
            triggerID += 1
        } label: {
            label(isLoading)
        }
        .disabled(disableOnLoading && isLoading)
        .task(id: triggerID) {
            guard triggerID > 0 else { return }
            isLoading = true
            defer { isLoading = false }
            await action()
        }
    }
}

extension AsyncButton where Label == Text {
    init(_ title: String, action: @escaping () async -> Void) {
        self.init(action: action) { _ in Text(title) }
    }
}
