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
    @State private var upcomingMovies: [Movie] = []
    @State private var topRatedMovies: [Movie] = []
    @State private var error: Error?
    @State private var selectedTab: Tab = .home

    enum Tab: String, CaseIterable {
        case home = "Popular"
        case newIn = "New in"
        case upcoming = "Upcoming"
        case topRated = "Top Rated"

        var section: String {
            switch self {
                case .home:
                    "Popular Movies"

                case .newIn:
                    "Now in Theaters"

                case .upcoming:
                    "Upcoming Movies"

                case .topRated:
                    "Top Rated Movies"
            }
        }
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView

                // Tab bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Tab.allCases, id: \.rawValue) { tab in
                            LabelTab(title: tab.rawValue, isSelected: selectedTab == tab)
                                .onTapGesture {
                                    withAnimation(.easeInOut) {
                                        selectedTab = tab
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)
                }

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
        ZStack(alignment: .top) {
            VStack(spacing: 32) {
                MovieGrid(
                    title: selectedTab.section,
                    movies:  {
                        switch selectedTab {
                            case .home: popularMovies
                            case .newIn: nowPlayingMovies
                            case .upcoming: upcomingMovies
                            case .topRated: topRatedMovies
                        }
                    }(),
                    onMovieTap: showMovieDetail,
                    cardSize: .large
                )

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(nowPlayingMovies.filter { $0.posterPath.isNotNil }) { movie in
                            FeaturedCardView(
                                url: movie.posterURL,
                                title: movie.title,
                                subtitle: movie.voteAverage.description
                            )
                                .onTapGesture {
                                    Task {
                                        await router.push(.movieDetail(movie))
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            if isLoading {
                loadingView
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.vertical, 100)
    }
}

// MARK: - Actions

private
extension HomeTabScreen {
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

    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let popularResponse = movieService.fetchPopularMovies()
            popularMovies = try await popularResponse.results

            async let nowPlayingResponse = movieService.fetchNowPlayingMovies()
            nowPlayingMovies = try await nowPlayingResponse.results

            async let upcomingResponse = movieService.fetchUpcomingMovies()
            upcomingMovies = try await upcomingResponse.results

            async let topRatedResponse = movieService.fetchTopRatedMovies()
            topRatedMovies = try await topRatedResponse.results
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

#endif

