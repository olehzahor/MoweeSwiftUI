//
//  SectionLoaderTests.swift
//  MoveeTests
//
//  Created by user on 11/30/25.
//

@testable import Movee
import XCTest

// MARK: - Mock Types

enum MockSection: Hashable {
    case section1
    case section2
    case section3
}

@MainActor
final class SectionLoaderTests: XCTestCase {
    var loader: SectionLoader<MockSection>!

    override func setUp() {
        super.setUp()
        loader = SectionLoader(sections: [.section1, .section2, .section3])
    }

    override func tearDown() {
        loader = nil
        super.tearDown()
    }

    // MARK: - Basic Functionality Tests

    func testInitialLoadStateIsIdle() {
        XCTAssertEqual(loader.loadState(for: .section1).isIdle, true)
    }

    func testFetchUpdatesLoadStateToLoading() async {
        // Given
        var fetchStarted = false
        let config = FetchConfig(priority: 1) {
            fetchStarted = true
            try await Task.sleep(for: .milliseconds(100))
            return "data"
        } update: { _ in
        }

        loader.setConfigs([.section1: config])

        // When
        let fetchTask = Task {
            await loader.fetch(.section1)
        }

        // Allow task to start
        try? await Task.sleep(for: .milliseconds(10))

        // Then
        XCTAssertTrue(fetchStarted)
        XCTAssertEqual(loader.loadState(for: .section1).isLoading, true)

        // Cleanup
        await fetchTask.value
    }

    func testFetchCompletesSuccessfully() async {
        // Given
        var updateCalled = false
        let config = FetchConfig(priority: 1) {
            return "data"
        } update: { _ in
            updateCalled = true
        }

        loader.setConfigs([.section1: config])

        // When
        await loader.fetch(.section1)

        // Then
        XCTAssertTrue(updateCalled)
        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
    }

    // MARK: - Concurrency Race Condition Tests
    func testConcurrentFetchCallsOnSameSection_OnlyLatestCompletes() async {
        // This tests that when multiple fetches are called rapidly,
        // only the latest one actually completes its work

        // Given
        var fetchCallCount = 0
        var completedFetchNumber: Int?

        let config = FetchConfig(priority: 1) {
            fetchCallCount += 1
            let myFetchNumber = fetchCallCount
            try await Task.sleep(for: .milliseconds(100))

            // If we get here, we weren't cancelled
            completedFetchNumber = myFetchNumber
            return "data"
        } update: { _ in
        }

        loader.setConfigs([.section1: config])

        // When - call fetch 3 times rapidly
        let task1 = Task { await loader.fetch(.section1) }
        try? await Task.sleep(for: .milliseconds(10))

        let task2 = Task { await loader.fetch(.section1) }
        try? await Task.sleep(for: .milliseconds(10))

        let task3 = Task { await loader.fetch(.section1) }

        await task1.value
        await task2.value
        await task3.value

        // Then
        // All three fetch calls were made
        XCTAssertEqual(fetchCallCount, 3)
        // But only the LATEST one (fetch #3) completed (others were cancelled)
        XCTAssertEqual(completedFetchNumber, 3)
        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
    }

    func testCancelledTaskDoesNotRestorePreviousState() async {
        // This specifically tests the UUID check in the cancellation handler

        // Given
        loader.updateLoadState(for: .section1, .loaded(isEmpty: false))

        var statesObserved: [Bool] = []  // Track isLoading states

        let config = FetchConfig(priority: 1) {
            // Long-running fetch that will be cancelled
            try await Task.sleep(for: .milliseconds(100))
            return "data"
        } update: { _ in
        }

        loader.setConfigs([.section1: config])

        // When
        // Start first fetch
        Task {
            await loader.fetch(.section1)
        }

        try? await Task.sleep(for: .milliseconds(20))
        statesObserved.append(loader.loadState(for: .section1).isLoading)

        // Start second fetch (cancels first)
        Task {
            await loader.fetch(.section1)
        }

        try? await Task.sleep(for: .milliseconds(150))

        // Then
        // We should have seen loading state
        XCTAssertTrue(statesObserved.contains(true))
        // Final state should be loaded, not restored to previous .loaded
        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
    }

    func testRapidCancellationAndRestart() async {
        // Tests rapid cancellation and restart scenario

        // Given
        var completedFetches = 0
        let config = FetchConfig(priority: 1) {
            try await Task.sleep(for: .milliseconds(100))
            return "data"
        } update: { _ in
            completedFetches += 1
        }

        loader.setConfigs([.section1: config])

        // When - start multiple fetches in quick succession
        let task1 = Task { await loader.fetch(.section1) }
        try? await Task.sleep(for: .milliseconds(10))

        let task2 = Task { await loader.fetch(.section1) }
        try? await Task.sleep(for: .milliseconds(10))

        let task3 = Task { await loader.fetch(.section1) }

        await task1.value
        await task2.value
        await task3.value

        // Then - at least one should complete
        XCTAssertGreaterThanOrEqual(completedFetches, 1)
        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
    }

    // MARK: - Error Handling Tests

    func testFetchWithError() async {
        // Given
        struct TestError: Error {}
        let config = FetchConfig(priority: 1) {
            throw TestError()
        } update: { (_: String) in
        }

        loader.setConfigs([.section1: config])

        // When
        await loader.fetch(.section1)

        // Then
        XCTAssertNotNil(loader.loadState(for: .section1).error)
    }

    func testFetchWithNoConfig() async {
        // When - fetch section without config
        await loader.fetch(.section1)

        // Then
        XCTAssertNotNil(loader.loadState(for: .section1).error)
    }

    // MARK: - Cancel Tests

    func testCancelAllStopsFetches() async {
        // Given
        var fetchCompleted = false
        let config = FetchConfig(priority: 1) {
            try await Task.sleep(for: .milliseconds(100))
            return "data"
        } update: { _ in
            fetchCompleted = true
        }

        loader.setConfigs([.section1: config])

        // When
        Task {
            await loader.fetch(.section1)
        }

        try? await Task.sleep(for: .milliseconds(10))
        loader.cancelAll()

        try? await Task.sleep(for: .milliseconds(200))

        // Then - fetch should not complete
        XCTAssertFalse(fetchCompleted)
    }
}
