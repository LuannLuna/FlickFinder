//
//  FlickFinderApp.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI
import SwiftData

@main
struct FlickFinderApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    let service = MovieService.preview

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .environment(service)
        .environmentObject(ThemeManager.shared)
        .modelContainer(sharedModelContainer)
    }
}
