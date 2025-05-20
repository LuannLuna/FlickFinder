//
//  TabView.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

enum Tab: Int, Hashable {
    case home
    case browse
    case watch
    case profile
    
    var icon: String {
        switch self {
            case .home:
                "house.fill"
            case .browse:
                "square.grid.2x2"
            case .watch:
                "circle"
            case .profile:
                "person.crop.circle"
        }
    }

    var label: String {
        switch self {
            case .home:
                "Home"
            case .browse:
                "Browse"
            case .watch:
                "Watch"
            case .profile:
                "Profile"
        }
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            ForEach([Tab.home, .browse, .watch, .profile], id: \.rawValue) { tab in
                TabBarItem(
                    icon: tab.icon,
                    label: tab.label,
                    isSelected: selectedTab == tab
                )
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.8))
    }
}

#if DEBUG
struct CustomTabViewWrapper: View {
    @State var tab: Tab = .home

    var body: some View {
        CustomTabView(selectedTab: $tab)
    }
}

#endif

#Preview {
    CustomTabViewWrapper()
}
