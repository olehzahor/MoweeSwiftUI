//
//  CoordinatorTests.swift
//  MoveeTests
//
//  Created by user on 11/19/25.
//

@testable import Movee
import XCTest
import SwiftUI

// MARK: - Mock Types

enum MockRoute: Route, Equatable {
    case screen1
    case screen2
    case screen3

    var id: Self { self }

    var view: some View {
        EmptyView()
    }
}

@MainActor
final class MockCoordinator: Coordinator {
    typealias RouteType = MockRoute

    @Published var path = NavigationPath()
    @Published var presentedSheet: MockRoute?
    @Published var presentedFullScreen: MockRoute?

    let logger: CoordinatorLogger?

    init(logger: CoordinatorLogger? = nil) {
        self.logger = logger
    }
}

@MainActor
final class MockLogger: CoordinatorLogger {
    var loggedMessages: [String] = []

    func logCoordinatorInfo(_ message: String) {
        loggedMessages.append(message)
    }

    func logCoordinatorError(_ message: String) {
        loggedMessages.append("ERROR: \(message)")
    }
}

// MARK: - Tests

@MainActor
final class CoordinatorTests: XCTestCase {
    var coordinator: MockCoordinator!

    override func setUp() {
        super.setUp()
        coordinator = MockCoordinator()
    }

    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }

    // MARK: - Push Tests

    func testPushAddsRouteToPath() {
        // Given
        let route = MockRoute.screen1

        // When
        coordinator.push(route)

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testPushMultipleRoutes() {
        // When
        coordinator.push(.screen1)
        coordinator.push(.screen2)

        // Then
        XCTAssertEqual(coordinator.path.count, 2)
    }

    // MARK: - Pop Tests

    func testPopRemovesLastRoute() {
        // Given
        coordinator.push(.screen1)
        coordinator.push(.screen2)

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testPopOnEmptyPathDoesNothing() {
        // Given - empty path

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 0)
    }

    // MARK: - Pop to Root Tests

    func testPopToRootClearsAllRoutes() {
        // Given
        coordinator.push(.screen1)
        coordinator.push(.screen2)
        coordinator.push(.screen3)

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertEqual(coordinator.path.count, 0)
    }

    func testPopToRootOnEmptyPathDoesNothing() {
        // Given - empty path

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertEqual(coordinator.path.count, 0)
    }

    // MARK: - Present Sheet Tests

    func testPresentSheetSetsSheetRoute() {
        // Given
        let route = MockRoute.screen1

        // When
        coordinator.present(route, style: .sheet)

        // Then
        XCTAssertNotNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    func testPresentSheetDefaultStyle() {
        // Given
        let route = MockRoute.screen1

        // When
        coordinator.present(route)

        // Then
        XCTAssertNotNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    // MARK: - Present Full Screen Tests

    func testPresentFullScreenSetsFullScreenRoute() {
        // Given
        let route = MockRoute.screen1

        // When
        coordinator.present(route, style: .fullScreenCover)

        // Then
        XCTAssertNil(coordinator.presentedSheet)
        XCTAssertNotNil(coordinator.presentedFullScreen)
    }

    // MARK: - Dismiss Tests

    func testDismissClearsSheet() {
        // Given
        coordinator.present(.screen1, style: .sheet)

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedSheet)
    }

    func testDismissClearsFullScreen() {
        // Given
        coordinator.present(.screen1, style: .fullScreenCover)

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    func testDismissClearsBothPresentations() {
        // Given
        coordinator.present(.screen1, style: .sheet)
        coordinator.presentedFullScreen = .screen2

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    // MARK: - Route Identity Tests

    func testRouteIdentity() {
        // Given
        let route1 = MockRoute.screen1
        let route2 = MockRoute.screen1

        // Then
        XCTAssertEqual(route1.id, route2.id)
    }

    func testDifferentRoutesHaveDifferentIdentities() {
        // Given
        let route1 = MockRoute.screen1
        let route2 = MockRoute.screen2

        // Then
        XCTAssertNotEqual(route1.id, route2.id)
    }

    // MARK: - Integration Tests

    func testComplexNavigationFlow() {
        // When - simulate a complex flow
        coordinator.push(.screen1)
        coordinator.push(.screen2)
        coordinator.pop()
        coordinator.push(.screen3)

        // Then
        XCTAssertEqual(coordinator.path.count, 2)
    }

    func testNavigationAndPresentationIndependence() {
        // When
        coordinator.push(.screen1)
        coordinator.present(.screen2, style: .sheet)

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
        XCTAssertNotNil(coordinator.presentedSheet)
    }

    // MARK: - Route Value Tests

    func testPresentedSheetContainsCorrectRoute() {
        // When
        coordinator.present(.screen2, style: .sheet)

        // Then
        XCTAssertEqual(coordinator.presentedSheet, .screen2)
    }

    func testPresentedFullScreenContainsCorrectRoute() {
        // When
        coordinator.present(.screen3, style: .fullScreenCover)

        // Then
        XCTAssertEqual(coordinator.presentedFullScreen, .screen3)
    }

    // MARK: - Presentation Override Tests

    func testPresentSheetOverridesPreviousSheet() {
        // Given
        coordinator.present(.screen1, style: .sheet)

        // When
        coordinator.present(.screen2, style: .sheet)

        // Then
        XCTAssertEqual(coordinator.presentedSheet, .screen2)
    }

    func testPresentFullScreenOverridesPreviousFullScreen() {
        // Given
        coordinator.present(.screen1, style: .fullScreenCover)

        // When
        coordinator.present(.screen3, style: .fullScreenCover)

        // Then
        XCTAssertEqual(coordinator.presentedFullScreen, .screen3)
    }

    func testPresentSheetDoesNotAffectFullScreen() {
        // Given
        coordinator.present(.screen1, style: .fullScreenCover)

        // When
        coordinator.present(.screen2, style: .sheet)

        // Then
        XCTAssertEqual(coordinator.presentedSheet, .screen2)
        XCTAssertEqual(coordinator.presentedFullScreen, .screen1)
    }

    // MARK: - Edge Case Tests

    func testMultiplePopsBeyondPathDoesNotCrash() {
        // Given
        coordinator.push(.screen1)

        // When
        coordinator.pop()
        coordinator.pop()
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 0)
    }

    func testDismissWhenNothingPresentedDoesNotCrash() {
        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    func testPushDoesNotAffectPresentations() {
        // Given
        coordinator.present(.screen1, style: .sheet)

        // When
        coordinator.push(.screen2)
        coordinator.push(.screen3)

        // Then
        XCTAssertEqual(coordinator.presentedSheet, .screen1)
        XCTAssertEqual(coordinator.path.count, 2)
    }

    // MARK: - Logger Tests

    func testPushLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)

        // When
        coordinator.push(.screen1)

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Push"))
        XCTAssertTrue(logger.loggedMessages[0].contains("screen1"))
    }

    func testPopLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)
        coordinator.push(.screen1)
        logger.loggedMessages.removeAll()

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Pop"))
    }

    func testPopToRootLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)
        coordinator.push(.screen1)
        coordinator.push(.screen2)
        logger.loggedMessages.removeAll()

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Pop to root"))
    }

    func testPresentSheetLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)

        // When
        coordinator.present(.screen2, style: .sheet)

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Present sheet"))
        XCTAssertTrue(logger.loggedMessages[0].contains("screen2"))
    }

    func testPresentFullScreenLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)

        // When
        coordinator.present(.screen3, style: .fullScreenCover)

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Present full screen"))
        XCTAssertTrue(logger.loggedMessages[0].contains("screen3"))
    }

    func testDismissLogsCorrectMessage() {
        // Given
        let logger = MockLogger()
        let coordinator = MockCoordinator(logger: logger)
        coordinator.present(.screen1, style: .sheet)
        logger.loggedMessages.removeAll()

        // When
        coordinator.dismiss()

        // Then
        XCTAssertEqual(logger.loggedMessages.count, 1)
        XCTAssertTrue(logger.loggedMessages[0].contains("Dismiss"))
    }

    func testCoordinatorWithoutLoggerDoesNotCrash() {
        // Given
        let coordinator = MockCoordinator(logger: nil)

        // When/Then - should not crash
        coordinator.push(.screen1)
        coordinator.pop()
        coordinator.present(.screen2, style: .sheet)
        coordinator.dismiss()
        coordinator.popToRoot()

        // Verify operations worked
        XCTAssertEqual(coordinator.path.count, 0)
        XCTAssertNil(coordinator.presentedSheet)
    }
}
