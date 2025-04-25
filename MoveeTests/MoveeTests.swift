//
//  MoveeTests.swift
//  MoveeTests
//
//  Created by user on 4/3/25.
//

@testable import Movee
import XCTest

class MediaConversionTests: XCTestCase {
    
    // Test the conversion from a Movie instance to a Media instance.
    func testMovieConversion() {
        // Arrange: Create a sample Movie with test data.
        let movie = Movie(
            id: 1,
            adult: false,
            backdropPath: "/backdrop.jpg",
            belongsToCollection: nil,
            budget: 100_000_000,
            genreIDs: [28, 12],
            genres: nil,
            homepage: "https://moviehomepage.com",
            imdbID: "tt1234567",
            originalLanguage: "en",
            originalTitle: "Original Movie Title",
            overview: "This is a movie overview.",
            popularity: 8.5,
            posterPath: "/poster.jpg",
            productionCompanies: nil,
            productionCountries: nil,
            releaseDate: "2021-01-01",
            revenue: 150_000_000,
            runtime: 120,
            spokenLanguages: nil,
            status: "Released",
            tagline: "This is a tagline",
            title: "Movie Title",
            video: false,
            voteAverage: 7.5,
            voteCount: 2000
        )
        
        // Act: Convert to Media using the movie initializer.
        let media = Media(movie: movie)
        
        // Assert: Check common media properties.
        XCTAssertEqual(media.id, movie.id)
        XCTAssertEqual(media.mediaType, .movie)
        XCTAssertEqual(media.title, movie.title)
        XCTAssertEqual(media.originalTitle, movie.originalTitle)
        XCTAssertEqual(media.overview, movie.overview)
        XCTAssertEqual(media.posterPath, movie.posterPath)
        XCTAssertEqual(media.backdropPath, movie.backdropPath)
        XCTAssertEqual(media.popularity, movie.popularity)
        XCTAssertEqual(media.voteAverage, movie.voteAverage)
        XCTAssertEqual(media.voteCount, movie.voteCount)
        XCTAssertEqual(media.releaseDate, movie.releaseDate)
        XCTAssertEqual(media.genreIDs, movie.genreIDs ?? [])
        
        // Assert: Verify that extra info contains movie-specific details.
        if case .movie(let movieExtra) = media.extra {
            XCTAssertEqual(movieExtra.budget, movie.budget)
            XCTAssertEqual(movieExtra.tagline, movie.tagline)
            XCTAssertEqual(movieExtra.adult, movie.adult)
            // Optionally add more assertions for additional fields from MovieExtra
        } else {
            XCTFail("Expected Media.extra to be of movie type.")
        }
    }
    
    // Test the conversion from a TVShow instance to a Media instance.
    func testTVShowConversion() {
        // Arrange: Create a sample TVShow with test data.
        let tvShow = TVShow(
            id: 2,
            originalName: "Original TV Show Name",
            name: "TV Show Title",
            posterPath: "/tvposter.jpg",
            backdropPath: "/tvbackdrop.jpg",
            createdBy: nil,
            episodeRunTime: [45],
            firstAirDate: "2020-05-05",
            genreIDs: [35],
            genres: nil,
            homepage: "https://tvhomepage.com",
            inProduction: false,
            languages: ["en"],
            lastAirDate: "2021-06-06",
            lastEpisodeToAir: nil,
            nextEpisodeToAir: nil,
            networks: nil,
            numberOfEpisodes: 10,
            numberOfSeasons: 1,
            originCountry: ["US"],
            originalLanguage: "en",
            overview: "TV Show Overview.",
            popularity: 9.0,
            productionCompanies: nil,
            seasons: nil,
            status: "Ended",
            type: "Scripted",
            voteAverage: 8.0,
            voteCount: 500
        )
        
        // Act: Convert to Media using the tvShow initializer.
        let media = Media(tvShow: tvShow)
        
        // Assert: Check common media properties.
        XCTAssertEqual(media.id, tvShow.id)
        XCTAssertEqual(media.mediaType, .tvShow)
        XCTAssertEqual(media.title, tvShow.name)
        XCTAssertEqual(media.originalTitle, tvShow.originalName)
        XCTAssertEqual(media.overview, tvShow.overview)
        XCTAssertEqual(media.posterPath, tvShow.posterPath)
        XCTAssertEqual(media.backdropPath, tvShow.backdropPath)
        XCTAssertEqual(media.popularity, tvShow.popularity)
        XCTAssertEqual(media.voteAverage, tvShow.voteAverage)
        XCTAssertEqual(media.voteCount, tvShow.voteCount)
        XCTAssertEqual(media.releaseDate, tvShow.firstAirDate)
        XCTAssertEqual(media.genreIDs, tvShow.genreIDs)
        
        // Assert: Verify that extra info contains tv-show-specific details.
        if case .tvShow(let tvShowExtra) = media.extra {
            XCTAssertEqual(tvShowExtra.episodeRunTime, tvShow.episodeRunTime)
            XCTAssertEqual(tvShowExtra.numberOfEpisodes, tvShow.numberOfEpisodes)
            XCTAssertEqual(tvShowExtra.numberOfSeasons, tvShow.numberOfSeasons)
            XCTAssertEqual(tvShowExtra.inProduction, tvShow.inProduction)
            // Optionally add more assertions for additional fields from TVShowExtra
        } else {
            XCTFail("Expected Media.extra to be of tvShow type.")
        }
    }
}
