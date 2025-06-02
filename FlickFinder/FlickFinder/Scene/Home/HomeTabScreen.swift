import SwiftUI

// MARK: - Home Tab View

struct HomeTabScreen: View {
    // MARK: - Dependencies
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(MovieService.self) private var movieService: MovieService
    @State private var isLoading = false

    @State private var popularMovies: [Movie] = []
    @State private var nowPlayingMovies: [Movie] = []
    @State private var error: Error?

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView
                contentView
                Spacer()
            }
            .padding(.bottom, 24)
        }
        .withNavigation(router: router)
        .task {
            await loadData()
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            Text("Home")
                .font(.largeTitle.bold())
                .foregroundColor(themeManager.textColor)
            Spacer()
            searchButton
        }
        .padding()
    }
    
    private var searchButton: some View {
        Button(action: showSearch) {
            Circle()
                .fill(themeManager.accentColor)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(themeManager.backgroundColor)
                )
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if isLoading && popularMovies.isEmpty {
            loadingView
        } else {
            VStack(spacing: 32) {
                // Popular Movies
                MovieGrid(
                    title: "Popular Movies",
                    movies: popularMovies,
                    onMovieTap: showMovieDetail,
                    cardSize: .large
                )
                
                // Now Playing
                MovieGrid(
                    title: "Now in Theaters",
                    movies: nowPlayingMovies,
                    onMovieTap: showMovieDetail,
                    cardSize: .medium
                )
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 100)
    }
    
    // MARK: - Actions
    
    private func showSearch() {
        Task {
            await router.push(.search(""))
        }
    }
    
    private func showMovieDetail(_ movie: Movie) {
        Task {
            await router.push(.movieDetail(movie))
        }
    }
}

private
extension HomeTabScreen {
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let popularResponse = movieService.fetchPopularMovies()
            popularMovies = try await popularResponse.results

            async let nowPlayingResponse = movieService.fetchNowPlayingMovies()
            nowPlayingMovies = try await nowPlayingResponse.results
        } catch {
            self.error = error
            print("Failed to fetch movies: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview Views
#if DEBUG

#Preview {
    HomeTabScreen()
        .environment(MovieService.preview)
        .environmentObject(ThemeManager.shared)
        .environment(NavigationRouter())
}

struct BrowseView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    @State private var themeManager = ThemeManager.shared

    var body: some View {
        Button {
            Task {
                await router.push(.watchlist)
            }
        } label: {
            Text("Browse")
                .foregroundColor(themeManager.textColor)
        }
        .withNavigation(router: router)
    }
}

struct WatchView: View {
    @State private var themeManager = ThemeManager.shared

    var body: some View {
        Text("Watch")
            .foregroundColor(themeManager.textColor)
    }
}

#endif

