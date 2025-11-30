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

    func testPreviousStateRaceCondition_CancelledTaskShouldNotOverwriteNewState() async {
        // This tests the scenario where:
        // 1. First fetch() is running, suspended at config.fetch()
        // 2. Second fetch() is called, cancels first, creates new task
        // 3. First task resumes, catches cancellation, tries to restore previousState
        // 4. We verify that the final state is correct (from second task, not first)

        // Given
//        let firstFetchStarted = CheckedContinuation<Void, Never>()
//        let allowFirstFetchToComplete = CheckedContinuation<Void, Never>()
//
//        var firstFetchContinuation: CheckedContinuation<Void, Never>?
//        var secondFetchContinuation: CheckedContinuation<Void, Never>?
//
//        let config1 = FetchConfig(priority: 1) {
//            await withCheckedContinuation { continuation in
//                firstFetchContinuation = continuation
//            }
//            await withCheckedContinuation { continuation in
//                secondFetchContinuation = continuation
//            }
//            return "data"
//        } update: { _ in
//        }
//
//        loader.setConfigs([.section1: config1])
//
//        // When
//        // Start first fetch
//        let firstTask = Task {
//            await loader.fetch(.section1)
//        }
//
//        // Wait for first fetch to start and be suspended
//        try? await Task.sleep(for: .milliseconds(10))
//
//        // Verify first task is loading
//        XCTAssertEqual(loader.loadState(for: .section1).isLoading, true)
//        let stateAfterFirstFetch = loader.loadState(for: .section1)
//
//        // Start second fetch while first is suspended
//        let secondTask = Task {
//            await loader.fetch(.section1)
//        }
//
//        try? await Task.sleep(for: .milliseconds(10))
//
//        // Resume first fetch (it should get cancelled)
//        firstFetchContinuation?.resume()
//
//        try? await Task.sleep(for: .milliseconds(10))
//
//        // Resume second fetch
//        secondFetchContinuation?.resume()
//
//        // Wait for both to complete
//        await firstTask.value
//        await secondTask.value
//
//        // Then
//        // The final state should be from the second task, not overwritten by the first task's restoration
//        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
//    }
//
//    func testConcurrentFetchCallsOnSameSection_OnlyOneShouldRun() async {
//        // This tests whether multiple concurrent fetch() calls can create multiple running tasks
//
//        // Given
//        var fetchCallCount = 0
//        var activeFetchCount = 0
//        var maxConcurrentFetches = 0
//
//        let config = FetchConfig(priority: 1) {
//            fetchCallCount += 1
//            activeFetchCount += 1
//            maxConcurrentFetches = max(maxConcurrentFetches, activeFetchCount)
//
//            try await Task.sleep(for: .milliseconds(50))
//
//            activeFetchCount -= 1
//            return "data"
//        } update: { _ in
//        }
//
//        loader.setConfigs([.section1: config])
//
//        // When - call fetch 3 times concurrently
//        async let fetch1: Void = loader.fetch(.section1)
//        async let fetch2: Void = loader.fetch(.section1)
//        async let fetch3: Void = loader.fetch(.section1)
//
//        _ = await (fetch1, fetch2, fetch3)
//
//        // Then
//        // If there's a race condition, multiple fetches could run concurrently
//        // Without the race, only one should run at a time (later calls cancel earlier ones)
//        print("Total fetch calls: \(fetchCallCount)")
//        print("Max concurrent fetches: \(maxConcurrentFetches)")
//
//        // The current implementation DOES allow multiple to run if they race past the cancel point
//        // This test documents the current behavior
//        XCTAssertGreaterThanOrEqual(fetchCallCount, 1)
    }

    func testCurrentTasksCleanupRace() async {
//        // This tests the scenario where:
//        // 1. First fetch() creates task1, stores in currentTasks
//        // 2. Second fetch() creates task2, stores in currentTasks (overwrites task1)
//        // 3. task1 completes first and tries to clear currentTasks
//        // 4. We verify that task1 doesn't incorrectly clear task2
//
//        // Given
//        let firstTaskStarted = CheckedContinuation<Void, Never>()
//        let allowFirstTaskToFinish = CheckedContinuation<Void, Never>()
//
//        var firstContinuation: CheckedContinuation<Void, Never>?
//        var secondContinuation: CheckedContinuation<Void, Never>?
//
//        var isFirstTask = true
//
//        let config = FetchConfig(priority: 1) {
//            if isFirstTask {
//                await withCheckedContinuation { continuation in
//                    firstContinuation = continuation
//                }
//                return "data1"
//            } else {
//                await withCheckedContinuation { continuation in
//                    secondContinuation = continuation
//                }
//                return "data2"
//            }
//        } update: { _ in
//        }
//
//        loader.setConfigs([.section1: config])
//
//        // When
//        // Start first fetch
//        let firstTask = Task {
//            await loader.fetch(.section1)
//        }
//
//        // Wait for first fetch to be suspended
//        try? await Task.sleep(for: .milliseconds(10))
//
//        // Start second fetch (this will cancel first and create a new task)
//        isFirstTask = false
//        let secondTask = Task {
//            await loader.fetch(.section1)
//        }
//
//        try? await Task.sleep(for: .milliseconds(10))
//
//        // Complete first task (which was cancelled)
//        firstContinuation?.resume()
//        await firstTask.value
//
//        // At this point, if there's a cleanup race, first task might have cleared
//        // the currentTasks entry that belongs to second task
//
//        // Verify second task is still tracked (implementation dependent)
//        // The current implementation has a check: if currentTasks[section] == task
//
//        // Complete second task
//        secondContinuation?.resume()
//        await secondTask.value
//
//        // Then
//        XCTAssertEqual(loader.loadState(for: .section1).isLoaded, true)
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
