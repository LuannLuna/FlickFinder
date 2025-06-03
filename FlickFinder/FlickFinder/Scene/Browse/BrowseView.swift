//
//  BrowseView.swift
//  FlickFinder
//
//  Created by Luann Luna on 02/06/25.
//

import SwiftUI

struct BrowseView: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    @EnvironmentObject private var themeManager: ThemeManager

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
