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

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .yellow : .gray)
            if !label.isEmpty {
                Text(label)
                    .font(.caption)
                    .foregroundColor(isSelected ? .yellow : .gray)
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
} 
