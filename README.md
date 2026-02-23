# Movee

`Movee` is a SwiftUI iOS app for discovering and browsing movies, TV shows, and people data from TMDB.

The project includes:
- a curated home feed (`Explore`),
- full search across movies/TV/people,
- advanced filtering,
- a media details screen (overview, seasons, videos, reviews, credits, recommendations, collections),
- local `Watchlist` and `Search History` powered by SwiftData.

## What's Inside

### Core Features
- `Explore`: section-based content feeds (popular/top rated/now playing, etc.)
- `Search`: multi-search with dedicated scopes (movies / tv / people)
- `Advanced Search`: genre and filter-based discovery via `Discover` endpoints
- `Media Details`: aggregated screen with staged section loading
- `Season Details`: episode-level season browsing
- `Watchlist` and `Search History`: local persistence with SwiftData

### Architecture
- UI: `SwiftUI`
- DI: `Factory`
- Networking: custom `NetworkClient` + `Endpoint` abstraction + interceptors
- Data sources:
  - `TMDB API` for primary content
  - `Mowee` (`explore.json`) for curated collection lists
- Navigation: coordinator pattern (`AppCoordinator`, `Route`)
- State handling: `@Observable`, `LoadState`, `SectionLoader`, `PagedDataSource`

### Technical Details
- Language: `Swift 5`
- Minimum iOS version: `18.0`
- Network caching: configured in `MoveeApp` via `URLCache`
- Tests: unit tests for `Coordinator`, `SectionLoader`, `PagedDataSource`

## Quick Start

1. Open the project:
```bash
open Movee.xcodeproj
```

2. Create the API keys file (ignored by Git):
`/Users/user/Documents/Movee/Movee/Configuration/APIKeys.swift`

Contents:
```swift
import Foundation

enum APIKeys {
    static let tmdb = "YOUR_TMDB_API_KEY"
}
```

3. Select the `Movee` scheme and run the app in Xcode.

## Tests

Run unit tests from Xcode (`MoveeTests`) or via CLI:
```bash
xcodebuild test -project Movee.xcodeproj -scheme Movee -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Project Structure

- `Movee/Scenes` - screens and view models
- `Movee/Network` - API layer (`Core`, `TMDB`, `Mowee`)
- `Movee/Infrastructure` - coordinators, DI, shared components
- `Movee/Models` - domain and persistence models
- `MoveeTests` - unit tests
