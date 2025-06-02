//
//  RootView.swift
//  FlickFinder
//
//  Created by Luann Luna on 02/06/25.
//

import SwiftUI

struct RootView: View {
    @State var router = NavigationRouter()
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        NavigationStack(path: $router.navigationPath) {
            TabView(selection: $router.selectedTab) {
                HomeTabScreen()
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

#if DEBUG
#Preview {
    RootView()
        .environment(MovieService.preview)
        .environmentObject(ThemeManager.shared)
}
#endif
