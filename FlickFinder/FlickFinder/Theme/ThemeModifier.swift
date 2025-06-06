//
//  ThemeModifier.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct ThemeModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.colorScheme)
            .background(themeManager.backgroundColor.ignoresSafeArea())
            .environment(\.colorScheme, themeManager.colorScheme)
    }
}

extension View {
    func withTheme() -> some View {
        modifier(ThemeModifier())
    }
} 
