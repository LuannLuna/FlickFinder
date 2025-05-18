import SwiftUI

struct HomeView: View {
    @StateObject private var router = NavigationRouter()
    
    var body: some View {
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
    }
}

struct HomeTabView: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        VStack(spacing: 0) {
            // Top navigation
            HStack {
                Text("Home")
                    .font(.largeTitle.bold())
                Spacer()
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    )
                    .onTapGesture {
                        router.push(.search(""))
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
                                router.push(.movieDetail(Movie(
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
                .padding()
            }

            // "Recommend to you"
            Text("Recommend to you")
                .font(.title3.bold())
                .foregroundColor(.white)
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
    }
}

// MARK: - Preview Views
#if DEBUG
struct BrowseView: View {
    var body: some View {
        Text("Browse")
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct WatchView: View {
    var body: some View {
        Text("Watch")
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
#endif

#Preview {
    HomeView()
}
