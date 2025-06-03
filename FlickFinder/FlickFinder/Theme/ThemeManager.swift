//
//  ThemeManager.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

final class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    
    static let shared = ThemeManager()
    
    private init() {
        // Initialize with system preference if no user preference is set
        if !UserDefaults.standard.bool(forKey: "isDarkMode") {
            isDarkMode = getSystemDarkMode()
        }
    }
    
    private func getSystemDarkMode() -> Bool {
        #if os(iOS)
        return UITraitCollection.current.userInterfaceStyle == .dark
        #else
        return false
        #endif
    }
    
    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    var backgroundColor: Color {
        isDarkMode ? .black : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var secondaryColor: Color {
        isDarkMode ? .gray : .gray.opacity(0.5)
    }
    
    var accentColor: Color {
        .yellow
    }
} 
