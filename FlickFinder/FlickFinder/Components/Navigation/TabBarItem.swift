//
//  TabBarItem.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct TabBarItem: View {
    let icon: String
    let label: String
    var isSelected: Bool
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? themeManager.accentColor : themeManager.secondaryColor)
            if !label.isEmpty {
                Text(label)
                    .font(.caption)
                    .foregroundColor(isSelected ? themeManager.accentColor : themeManager.secondaryColor)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HStack {
        TabBarItem(icon: "house.fill", label: "Home", isSelected: true)
        TabBarItem(icon: "square.grid.2x2", label: "Browse", isSelected: false)
        TabBarItem(icon: "circle", label: "Watch", isSelected: false)
        TabBarItem(icon: "person.crop.circle", label: "Profile", isSelected: false)
    }
    .padding()
    .background(Color.black)
    .environmentObject(ThemeManager.shared)
}
