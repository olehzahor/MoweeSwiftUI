//
//  MoveeApp.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import SwiftUI
import SwiftData

enum AppContainer {
    static let shared: ModelContainer = {
        do {
            return try ModelContainer(for: WatchlistItem.self, SearchHistoryItem.self)
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }()
}

@main
struct MoveeApp: App {
    static let tintColor: UIColor = {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 1.0, green: 0.62, blue: 0.04, alpha: 1.0)
                : UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
        }
    }()

//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            WatchlistItem.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .accentColor(Color(MoveeApp.tintColor))

        }
        .modelContainer(AppContainer.shared)
    }
}
