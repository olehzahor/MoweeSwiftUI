//
//  ErrorRetryView.swift
//  Movee
//
//  Created on 24.10.2025.
//

import SwiftUI

struct ErrorRetryView: View {
    let error: Error
    let retry: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            Text("Error: \(error.localizedDescription)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            if let retry {
                Button("Retry", action: retry)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}
