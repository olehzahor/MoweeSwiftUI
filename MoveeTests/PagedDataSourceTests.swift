//
//  PagedDataSourceTests.swift
//  MoveeTests
//
//  Created by user on 11/30/25.
//

@testable import Movee
import XCTest

// MARK: - Mock Types

struct MockItem: Identifiable, Decodable {
    let id: Int
    let name: String
}

@MainActor
final class PagedDataSourceTests: XCTestCase {
    var dataSource: PagedDataSource<MockItem>!

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    // MARK: - Basic Functionality Tests

    func testInitialStateIsIdle() {
        // Given
        dataSource = PagedDataSource(
            loadNext: { PageLoadResult(items: [], hasMore: false, isFirstPage: true) },
            onRefresh: {}
        )

        // Then
        XCTAssertEqual(dataSource.loadState.isIdle, true)
        XCTAssertTrue(dataSource.items.isEmpty)
    }

    func testFetchLoadsItems() async {
        // Given
        let mockItems = [
            MockItem(id: 1, name: "Item 1"),
            MockItem(id: 2, name: "Item 2")
        ]

        dataSource = PagedDataSource(
            loadNext: {
                PageLoadResult(items: mockItems, hasMore: false, isFirstPage: true)
            },
            onRefresh: {}
        )

        // When
        await dataSource.fetch()

        // Then
        XCTAssertEqual(dataSource.items.count, 2)
        XCTAssertEqual(dataSource.loadState.isLoaded, true)
        XCTAssertFalse(dataSource.hasMorePages)
    }

    func testFetchHandlesError() async {
        // Given
        struct TestError: Error {}

        dataSource = PagedDataSource(
            loadNext: { throw TestError() },
            onRefresh: {}
        )

        // When
        await dataSource.fetch()

        // Then
        XCTAssertNotNil(dataSource.error)
        XCTAssertTrue(dataSource.items.isEmpty)
    }

    // MARK: - Concurrency Tests

    func testConcurrentFetchCallsAreBlocked() async {
        // This tests that the guard prevents concurrent fetches

        // Given
        var fetchCallCount = 0
        var completedFetchNumber: Int?

        dataSource = PagedDataSource(
            loadNext: {
                fetchCallCount += 1
                let myFetchNumber = fetchCallCount
                try await Task.sleep(for: .milliseconds(100))

                // If we get here, we completed
                completedFetchNumber = myFetchNumber
                return PageLoadResult(
                    items: [MockItem(id: myFetchNumber, name: "Item \(myFetchNumber)")],
                    hasMore: true,
                    isFirstPage: myFetchNumber == 1
                )
            },
            onRefresh: {}
        )

        // When - call fetch 3 times rapidly
        let task1 = Task { await dataSource.fetch() }
        try? await Task.sleep(for: .milliseconds(10))

        let task2 = Task { await dataSource.fetch() }
        try? await Task.sleep(for: .milliseconds(10))

        let task3 = Task { await dataSource.fetch() }

        await task1.value
        await task2.value
        await task3.value

        // Then
        // Only the first fetch should have run (guard blocks others while loading)
        XCTAssertEqual(fetchCallCount, 1)
        XCTAssertEqual(completedFetchNumber, 1)
        XCTAssertEqual(dataSource.items.count, 1)
        XCTAssertEqual(dataSource.loadState.isLoaded, true)
    }

    func testGuardBlocksFetchWhenLoading() async {
        // This specifically tests that the !loadState.isLoading guard works

        // Given
        var firstFetchStarted = false
        var secondFetchAttempted = false

        dataSource = PagedDataSource(
            loadNext: {
                if !firstFetchStarted {
                    firstFetchStarted = true
                    try await Task.sleep(for: .milliseconds(100))
                } else {
                    secondFetchAttempted = true
                }
                return PageLoadResult(items: [], hasMore: false, isFirstPage: true)
            },
            onRefresh: {}
        )

        // When
        let task1 = Task { await dataSource.fetch() }

        // Wait for first fetch to start and set .loading state
        try? await Task.sleep(for: .milliseconds(20))
        XCTAssertTrue(firstFetchStarted)
        XCTAssertEqual(dataSource.loadState.isLoading, true)

        // Try to fetch again while first is loading
        await dataSource.fetch()

        await task1.value

        // Then
        // Second fetch should have been blocked by guard
        XCTAssertFalse(secondFetchAttempted)
        XCTAssertEqual(dataSource.loadState.isLoaded, true)
    }

    func testRefreshCancelsOngoingFetch() async {
        // Tests that refresh() properly cancels ongoing fetches

        // Given
        var firstFetchStarted = false
        var firstFetchCompleted = false
        var refreshFetchCompleted = false

        dataSource = PagedDataSource(
            loadNext: {
                if !firstFetchStarted {
                    firstFetchStarted = true
                    try await Task.sleep(for: .milliseconds(200))
                    firstFetchCompleted = true
                    return PageLoadResult(items: [MockItem(id: 1, name: "First")], hasMore: false, isFirstPage: true)
                } else {
                    refreshFetchCompleted = true
                    return PageLoadResult(items: [MockItem(id: 2, name: "Refresh")], hasMore: false, isFirstPage: true)
                }
            },
            onRefresh: {}
        )

        // When
        let firstTask = Task { await dataSource.fetch() }

        // Wait for first fetch to start
        try? await Task.sleep(for: .milliseconds(50))
        XCTAssertTrue(firstFetchStarted)

        // Refresh should cancel first fetch
        await dataSource.refresh()

        await firstTask.value

        // Then
        // First fetch should have been cancelled
        XCTAssertFalse(firstFetchCompleted)
        // Refresh fetch should have completed
        XCTAssertTrue(refreshFetchCompleted)
        XCTAssertEqual(dataSource.items.count, 1)
        XCTAssertEqual(dataSource.items.first?.id, 2)
    }

    func testMultiplePageLoads() async {
        // Tests sequential page loading

        // Given
        var currentPage = 0

        dataSource = PagedDataSource(
            loadNext: {
                currentPage += 1
                return PageLoadResult(
                    items: [MockItem(id: currentPage, name: "Page \(currentPage)")],
                    hasMore: currentPage < 3,
                    isFirstPage: currentPage == 1
                )
            },
            onRefresh: { currentPage = 0 }
        )

        // When
        await dataSource.fetch()  // Page 1
        await dataSource.fetch()  // Page 2
        await dataSource.fetch()  // Page 3
        await dataSource.fetch()  // Should be blocked (no more pages)

        // Then
        XCTAssertEqual(dataSource.items.count, 3)
        XCTAssertFalse(dataSource.hasMorePages)
        XCTAssertEqual(currentPage, 3)
    }

    func testGuardBlocksFetchWhenNoMorePages() async {
        // Given
        var fetchCount = 0

        dataSource = PagedDataSource(
            loadNext: {
                fetchCount += 1
                return PageLoadResult(items: [], hasMore: false, isFirstPage: true)
            },
            onRefresh: {}
        )

        // When
        await dataSource.fetch()  // First fetch
        await dataSource.fetch()  // Should be blocked (no more pages)
        await dataSource.fetch()  // Should be blocked (no more pages)

        // Then
        XCTAssertEqual(fetchCount, 1)
        XCTAssertFalse(dataSource.hasMorePages)
    }
}
