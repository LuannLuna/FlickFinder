//
//  ProfileView.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Button(action: themeManager.toggleTheme) {
            Text("Profile")
                .foregroundColor(themeManager.textColor)
        }
    }
}

#if DEBUG
#Preview {
    ProfileView()
        .environmentObject(ThemeManager.shared)
}
#endif
