//
//  FeaturedCardView.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct FeaturedCardView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: "https://via.placeholder.com/200")) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 200, height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle().fill(Color.red).frame(width: 6, height: 6)
                    Text("Gunfire Ranger")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                Text("Action  Character")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}

#Preview {
    FeaturedCardView()
}
