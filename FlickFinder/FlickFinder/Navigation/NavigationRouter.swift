//
//  NavigationRouter.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

protocol RouterProtocol: ObservableObject {
    var navigationPath: NavigationPath { get set }
    var selectedTab: Tab { get set }
    
    func push(_ route: Route) async
    func pop() async
    func popToRoot() async
    func switchTab(to tab: Tab) async
}

@MainActor
final class NavigationRouter: RouterProtocol, ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var selectedTab: Tab = .home
    
    private let analytics: AnalyticsMiddleware
    private var navigationStack: [Route] = []

    static let shared = NavigationRouter()
    
    init(analytics: AnalyticsMiddleware = AnalyticsManager.shared) {
        self.analytics = analytics
    }
    
    func push(_ route: Route) {
        navigationStack.append(route)
        navigationPath.append(route)
        analytics.track(NavigationEvent.screenView(route: route))
    }

    @MainActor
    func pop() {
        let route = navigationStack.removeLast()
        analytics.track(NavigationEvent.backNavigation(from: route, to: navigationStack.last))
        navigationPath.removeLast()
    }
    
    func popToRoot() {
        let route = navigationStack.removeLast()
        analytics.track(NavigationEvent.backNavigation(from: route, to: nil))
        navigationPath.removeLast(navigationPath.count)
    }
    
    func switchTab(to tab: Tab) {
        analytics.track(NavigationEvent.tabChange(from: selectedTab, to: tab))
        selectedTab = tab
        popToRoot()
    }
}

// MARK: - View Extension
extension View {
    func withNavigation() -> some View {
        let router = NavigationRouter.shared
        return NavigationStack(path: Binding(
            get: { router.navigationPath },
            set: { router.navigationPath = $0 }
        )) {
            self.navigationDestination(for: Route.self) { route in
                switch route {
                case .movieDetail(let movie):
                    MovieDetailView(movie: movie)
                case .search(let query):
                    SearchView(query: query)
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                case .watchlist:
                    WatchlistView()
                case .favorites:
                    FavoritesView()
                }
            }
        }
        .environmentObject(router)
    }
}

// MARK: - Preview Helpers
#if DEBUG
extension NavigationRouter {
    static var preview: NavigationRouter {
        NavigationRouter(analytics: AnalyticsManager.preview)
    }
}

// Preview Views
private struct MovieDetailView: View {
    @EnvironmentObject private var router: NavigationRouter
    let movie: Movie
    
    var body: some View {
        Text(movie.title)
    }
}

private struct SearchView: View {
    @EnvironmentObject private var router: NavigationRouter
    let query: String
    
    var body: some View {
        Text("Search: \(query)")
    }
}

private struct SettingsView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        Text("Settings")
    }
}

private struct WatchlistView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        Text("Watchlist")
    }
}

private struct FavoritesView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        Text("Favorites")
    }
}
#endif 
