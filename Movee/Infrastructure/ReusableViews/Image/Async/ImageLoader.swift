//
//  ImageLoader.swift
//  Movee
//
//  Created by user on 11/24/25.
//

import SwiftUI
import Observation

@MainActor @Observable
final class ImageLoader {
    private(set) var state: LoadState = .idle
    private(set) var image: UIImage?

    @ObservationIgnored
    private var currentTask: Task<Void, Never>?

    func load(url: URL?) async {
        guard let url else {
            state = .idle
            return
        }

        currentTask?.cancel()

        state = .loading

        let task = Task {
            do {
                image = try await ImageCache.shared.image(for: url)
                try Task.checkCancellation()
                state = .loaded(isEmpty: false)
            } catch {
                if !Task.isCancelled {
                    state = .error(error)
                }
            }
        }

        currentTask = task

        await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }

        currentTask = nil
    }

    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }

    func clear() {
        cancel()
        image = nil
        state = .idle
    }
}
