//
//  NavigationBackButton.swift
//  FlickFinder
//
//  Created by Luann Luna on 19/05/25.
//

import SwiftUI

struct NavigationBackButton: ToolbarContent {
    @Environment(NavigationRouter.self) private var router: NavigationRouter

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                Task {
                    await router.pop()
                }
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
            .tint(.primary)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        Text("Preview")
            .toolbar {
                NavigationBackButton()
            }
            .environment(NavigationRouter.preview)
    }
} 
