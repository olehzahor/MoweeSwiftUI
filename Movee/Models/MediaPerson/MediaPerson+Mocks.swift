//
//  MediaPerson+Mocks.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation

// MARK: - Preview Mocks
extension MediaPerson {
    static let mock = MediaPerson(
        person: Person(
            id: 1,
            name: "Robert Downey Jr.",
            department: "Acting",
            biography: "Robert Downey Jr. is an American actor and producer.",
            popularity: 50.5,
            profilePath: "/1YjdSym1jTG7xjHSI0yGGWEsw5i.jpg",
            knownFor: [
                .movie(Movie(
                    id: 1,
                    adult: false,
                    backdropPath: nil,
                    belongsToCollection: nil,
                    budget: nil,
                    genreIDs: [28, 878, 12],
                    genres: nil,
                    homepage: nil,
                    imdbID: nil,
                    originalLanguage: "en",
                    originalTitle: "Iron Man",
                    overview: "After being held captive in an Afghan cave, billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil.",
                    popularity: 100.5,
                    posterPath: "/78lPtwv72eTNqFW9COBYI0dWDJa.jpg",
                    productionCompanies: nil,
                    productionCountries: nil,
                    releaseDate: "2008-05-02",
                    revenue: nil,
                    runtime: 126,
                    spokenLanguages: nil,
                    status: nil,
                    tagline: nil,
                    title: "Iron Man",
                    video: false,
                    voteAverage: 7.6,
                    voteCount: 24000,
                    character: "Tony Stark / Iron Man",
                    job: nil
                )),
                .movie(Movie(
                    id: 2,
                    adult: false,
                    backdropPath: nil,
                    belongsToCollection: nil,
                    budget: nil,
                    genreIDs: [28, 12, 878],
                    genres: nil,
                    homepage: nil,
                    imdbID: nil,
                    originalLanguage: "en",
                    originalTitle: "Avengers: Endgame",
                    overview: "After the devastating events of Infinity War, the Avengers assemble once more.",
                    popularity: 200.8,
                    posterPath: "/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
                    productionCompanies: nil,
                    productionCountries: nil,
                    releaseDate: "2019-04-26",
                    revenue: nil,
                    runtime: 181,
                    spokenLanguages: nil,
                    status: nil,
                    tagline: nil,
                    title: "Avengers: Endgame",
                    video: false,
                    voteAverage: 8.3,
                    voteCount: 28000,
                    character: "Tony Stark / Iron Man",
                    job: nil
                )),
                .movie(Movie(
                    id: 3,
                    adult: false,
                    backdropPath: nil,
                    belongsToCollection: nil,
                    budget: nil,
                    genreIDs: [35, 80],
                    genres: nil,
                    homepage: nil,
                    imdbID: nil,
                    originalLanguage: "en",
                    originalTitle: "Sherlock Holmes",
                    overview: "Detective Sherlock Holmes and his partner Dr. Watson solve London's most baffling mysteries.",
                    popularity: 90.2,
                    posterPath: "/7G2VvZpdgWsWnMW1lTl51Jc9DO2.jpg",
                    productionCompanies: nil,
                    productionCountries: nil,
                    releaseDate: "2009-12-25",
                    revenue: nil,
                    runtime: 128,
                    spokenLanguages: nil,
                    status: nil,
                    tagline: nil,
                    title: "Sherlock Holmes",
                    video: false,
                    voteAverage: 7.2,
                    voteCount: 15000,
                    character: "Sherlock Holmes",
                    job: nil
                ))
            ],
            gender: 2
        )
    )

    static let mockWithoutMedia = MediaPerson(
        person: Person(
            id: 1,
            name: "Robert Downey Jr.",
            department: "Acting",
            biography: "Robert Downey Jr. is an American actor and producer.",
            popularity: 50.5,
            profilePath: "/1YjdSym1jTG7xjHSI0yGGWEsw5i.jpg",
            knownFor: [],
            gender: 2
        )
    )
}
