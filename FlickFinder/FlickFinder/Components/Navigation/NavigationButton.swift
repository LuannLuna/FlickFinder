//
//  NavigationButton.swift
//  FlickFinder
//
//  Created by Luann Luna on 19/05/25.
//

import SwiftUI

struct NavigationButton<Label: View>: View {
    @Environment(NavigationRouter.self) private var router: NavigationRouter
    let action: () async -> Void
    let label: Label
    
    init(action: @escaping () async -> Void, @ViewBuilder label: () -> Label) {
        self.action = action
        self.label = label()
    }
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            label
        }
    }
}

// MARK: - Convenience Initializers
extension NavigationButton where Label == Text {
    init(_ title: String, action: @escaping () async -> Void) {
        self.init(action: action) {
            Text(title)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationButton("Go Back") {
        await NavigationRouter.preview.pop()
    }
    .environment(NavigationRouter.preview)
} 
