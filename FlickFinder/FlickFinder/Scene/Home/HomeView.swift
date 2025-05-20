import SwiftUI

struct HomeView: View {
    @State var router = NavigationRouter()
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            TabView(selection: $router.selectedTab) {
                HomeTabView()
                    .tabItem {
                        TabBarItem(
                            icon: Tab.home.icon,
                            label: Tab.home.label,
                            isSelected: router.selectedTab == .home
                        )
                    }
                    .tag(Tab.home)

                BrowseView()
                    .tabItem {
                        TabBarItem(
                            icon: Tab.browse.icon,
                            label: Tab.browse.label,
                            isSelected: router.selectedTab == .browse
                        )
                    }
                    .tag(Tab.browse)

                WatchView()
                    .tabItem {
                        TabBarItem(
                            icon: Tab.watch.icon,
                            label: Tab.watch.label,
                            isSelected: router.selectedTab == .watch
                        )
                    }
                    .tag(Tab.watch)

                ProfileView()
                    .tabItem {
                        TabBarItem(
                            icon: Tab.profile.icon,
                            label: Tab.profile.label,
                            isSelected: router.selectedTab == .profile
                        )
                    }
                    .tag(Tab.profile)
            }
            .withNavigation(router: router)
            .withTheme()
        }
        .environment(router)
    }
}

struct HomeTabView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Top navigation
            HStack {
                Text("Home")
                    .font(.largeTitle.bold())
                    .foregroundColor(themeManager.textColor)
                Spacer()
                Circle()
                    .fill(themeManager.accentColor)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(themeManager.backgroundColor)
                    )
                    .onTapGesture {
                        Task {
                            await router.push(.search(""))
                        }
                    }
            }
            .padding()

            // Tab bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    LabelTab(title: "Popular", isSelected: true)
                    LabelTab(title: "New in")
                    LabelTab(title: "Action")
                    LabelTab(title: "Character")
                }
                .padding(.horizontal)
            }

            // Featured cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        FeaturedCardView()
                            .onTapGesture {
                                // TODO: Replace with actual movie data
                                Task {
                                    await router.push(.movieDetail(Movie(
                                        id: 1,
                                        title: "Sample Movie",
                                        overview: "Overview",
                                        posterPath: nil,
                                        backdropPath: nil,
                                        voteAverage: 0,
                                        voteCount: 0,
                                        releaseDate: "",
                                        popularity: 0,
                                        originalTitle: "",
                                        originalLanguage: "",
                                        genreIds: [],
                                        adult: false,
                                        video: false
                                    )))
                                }
                            }
                    }
                }
                .padding()
            }

            // "Recommend to you"
            Text("Recommend to you")
                .font(.title3.bold())
                .foregroundColor(themeManager.textColor)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        AsyncImage(url: URL(string: "https://via.placeholder.com/80")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding()
            }

            Spacer()
        }
        .withNavigation(router: router)
    }
}

// MARK: - Preview Views
#if DEBUG
struct BrowseView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    @ObservedObject private var themeManager = ThemeManager.shared
    
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
    @ObservedObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        Text("Watch")
            .foregroundColor(themeManager.textColor)
    }
}

#Preview {
    HomeView()
}
#endif
