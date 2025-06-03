//
//  WatchView.swift
//  FlickFinder
//
//  Created by Luann Luna on 02/06/25.
//

import SwiftUI

struct WatchView: View {
    @EnvironmentObject private var themeManager: ThemeManager

    var body: some View {
        Text("Watch")
            .foregroundColor(themeManager.textColor)
    }
}
