//
//  ProfileView.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var themeManager = ThemeManager.shared

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
}
#endif
