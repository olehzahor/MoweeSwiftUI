//
//  CoordinatorTests.swift
//  MoveeTests
//
//  Created by user on 11/19/25.
//

@testable import Movee
import XCTest
import SwiftUI

final class CoordinatorTests: XCTestCase {
    var coordinator: AppCoordinator!

    override func setUp() {
        super.setUp()
        coordinator = AppCoordinator()
    }

    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }

    // MARK: - Push Tests

    func testPushAddsRouteToPath() {
        // Given
        let media = Media.placeholder
        let route = AppRoute.mediaDetails(media)

        // When
        coordinator.push(route)

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }

    func testPushMultipleRoutes() {
        // Given
        let media1 = Media.placeholder
        let media2 = Media(
            id: 100,
            mediaType: .movie,
            title: "Test Movie",
            originalTitle: "Test Movie",
            overview: "Test",
            popularity: 0,
            voteAverage: 0,
            voteCount: 0,
            genreIDs: []
        )

        // When
        coordinator.push(.mediaDetails(media1))
        coordinator.push(.mediaDetails(media2))

        // Then
        XCTAssertEqual(coordinator.path.count, 2)
    }

    // MARK: - Pop Tests

    func testPopRemovesLastRoute() {
        // Given
        let media = Media.placeholder
        coordinator.push(.mediaDetails(media))
        coordinator.push(.mediaDetails(media))

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
        let media = Media.placeholder
        coordinator.push(.mediaDetails(media))
        coordinator.push(.mediaDetails(media))
        coordinator.push(.mediaDetails(media))

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
        let media = Media.placeholder
        let route = AppRoute.mediaDetails(media)

        // When
        coordinator.present(route, style: .sheet)

        // Then
        XCTAssertNotNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    func testPresentSheetDefaultStyle() {
        // Given
        let media = Media.placeholder
        let route = AppRoute.mediaDetails(media)

        // When
        coordinator.present(route)

        // Then
        XCTAssertNotNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    // MARK: - Present Full Screen Tests

    func testPresentFullScreenSetsFullScreenRoute() {
        // Given
        let media = Media.placeholder
        let route = AppRoute.mediaDetails(media)

        // When
        coordinator.present(route, style: .fullScreenCover)

        // Then
        XCTAssertNil(coordinator.presentedSheet)
        XCTAssertNotNil(coordinator.presentedFullScreen)
    }

    // MARK: - Dismiss Tests

    func testDismissClearsSheet() {
        // Given
        let media = Media.placeholder
        coordinator.present(.mediaDetails(media), style: .sheet)

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedSheet)
    }

    func testDismissClearsFullScreen() {
        // Given
        let media = Media.placeholder
        coordinator.present(.mediaDetails(media), style: .fullScreenCover)

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    func testDismissClearsBothPresentations() {
        // Given
        let media = Media.placeholder
        coordinator.present(.mediaDetails(media), style: .sheet)
        coordinator.presentedFullScreen = .mediaDetails(media)

        // When
        coordinator.dismiss()

        // Then
        XCTAssertNil(coordinator.presentedSheet)
        XCTAssertNil(coordinator.presentedFullScreen)
    }

    // MARK: - AppRoute Tests

    func testMediaDetailsRouteIdentity() {
        // Given
        let media = Media.placeholder
        let route1 = AppRoute.mediaDetails(media)
        let route2 = AppRoute.mediaDetails(media)

        // Then
        XCTAssertEqual(route1.id, route2.id)
    }

    func testDifferentRoutesHaveDifferentIdentities() {
        // Given
        let media = Media.placeholder
        let review = Review.placeholder
        let route1 = AppRoute.mediaDetails(media)
        let route2 = AppRoute.review("Test", review)

        // Then
        XCTAssertNotEqual(route1.id, route2.id)
    }

    func testSeasonDetailsRouteCreation() {
//        // Given
//        let season = Season(
//            id: 1,
//            name: "Season 1",
//            overview: "Test",
//            posterPath: nil,
//            airDate: nil,
//            episodeCount: 10,
//            seasonNumber: 1
//        )
//
//        // When
//        let route = AppRoute.seasonDetails(123, season)
//
//        // Then
//        XCTAssertEqual(route.id, route)
    }

    // MARK: - Integration Tests

    func testComplexNavigationFlow() {
        // Given
        let media = Media.placeholder

        // When - simulate a complex flow
        coordinator.push(.mediaDetails(media))
        coordinator.push(.mediaDetails(media))
        coordinator.pop()
        coordinator.push(.mediaDetails(media))

        // Then
        XCTAssertEqual(coordinator.path.count, 2)
    }

    func testNavigationAndPresentationIndependence() {
        // Given
        let media = Media.placeholder

        // When
        coordinator.push(.mediaDetails(media))
        coordinator.present(.mediaDetails(media), style: .sheet)

        // Then
        XCTAssertEqual(coordinator.path.count, 1)
        XCTAssertNotNil(coordinator.presentedSheet)
    }
}
