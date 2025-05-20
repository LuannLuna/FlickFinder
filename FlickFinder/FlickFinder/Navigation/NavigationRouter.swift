//
//  NavigationRouter.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

protocol RouterProtocol {
    var navigationPath: NavigationPath { get set }
    var selectedTab: Tab { get set }
    
    func push(_ route: Route) async
    func pop() async
    func popToRoot() async
    func switchTab(to tab: Tab) async
}

@Observable
final class NavigationRouter: RouterProtocol {
    var navigationPath = NavigationPath()
    var selectedTab: Tab = .home
    
    private let analytics: AnalyticsMiddleware
    private var navigationStack: [Route] = []
    
    init(analytics: AnalyticsMiddleware = AnalyticsManager.shared) {
        self.analytics = analytics
    }
    
    func push(_ route: Route) async {
        navigationStack.append(route)
        navigationPath.append(route)
        analytics.track(NavigationEvent.screenView(route: route))
    }
    
    func pop() async {
        guard !navigationStack.isEmpty else { return }
        let route = navigationStack.removeLast()
        analytics.track(NavigationEvent.backNavigation(from: route, to: navigationStack.last))
        navigationPath.removeLast()
    }
    
    func popToRoot() async {
        guard !navigationStack.isEmpty else { return }
        let route = navigationStack.removeLast()
        analytics.track(NavigationEvent.backNavigation(from: route, to: nil))
        navigationStack.removeAll()
        navigationPath.removeLast(navigationPath.count)
    }
    
    func switchTab(to tab: Tab) async {
        analytics.track(NavigationEvent.tabChange(from: selectedTab, to: tab))
        selectedTab = tab
        await popToRoot()
    }
}

// MARK: - View Extension
extension View {
    func withNavigation(router: NavigationRouter) -> some View {
        NavigationStack(path: Binding(
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
        .environment(router)
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
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    let movie: Movie
    
    var body: some View {
        Text(movie.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                NavigationBackButton()
            }
    }
}

private struct SearchView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    let query: String
    
    var body: some View {
        Text("Search: \(query)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                NavigationBackButton()
            }
    }
}

private struct SettingsView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    
    var body: some View {
        Text("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                NavigationBackButton()
            }
    }
}

private struct WatchlistView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    
    var body: some View {
        Text("Watchlist")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                NavigationBackButton()
            }
    }
}

private struct FavoritesView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    
    var body: some View {
        Text("Favorites")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                NavigationBackButton()
            }
    }
}
#endif 
