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

    @StateObject private var router = NavigationRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(
                path: $router.navigationPath) {
                    HomeView()
                        .environmentObject(router)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
