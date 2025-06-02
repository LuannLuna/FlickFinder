//
//  LabelTab.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct LabelTab: View {
    let title: String
    var isSelected: Bool = false
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Text(title)
            .foregroundColor(isSelected ? themeManager.accentColor : themeManager.secondaryColor)
            .bold()
            .padding(.bottom, 8)
            .overlay(
                isSelected ? Circle()
                    .fill(themeManager.accentColor)
                    .frame(width: 6, height: 6)
                    .offset(y: 10) : nil
            )
    }
}

#Preview {
    LabelTab(title: "Popular", isSelected: true)
        .withTheme()
        .environmentObject(ThemeManager.shared)
}
