//
//  TaskTrigger.swift
//  Movee
//
//  Created by user on 11/23/25.
//

import SwiftUI

@MainActor @Observable
final class TaskTrigger {
    private(set) var fireCount = 0

    func fire() {
        fireCount += 1
    }
}

extension View {
    func onFire(_ trigger: TaskTrigger, perform action: @escaping () async -> Void) -> some View {
        self.task(id: trigger.fireCount) {
            guard trigger.fireCount > 0 else { return }
            await action()
        }
    }
}
