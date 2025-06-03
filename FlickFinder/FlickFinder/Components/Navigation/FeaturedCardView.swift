//
//  FeaturedCardView.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import SwiftUI

struct FeaturedCardView: View {
    let url: URL?
    let title: String
    let subtitle: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Circle().fill(Color.red).frame(width: 6, height: 6)
                    Text(title)
                        .lineLimit(1)
                        .font(.footnote.bold())
                        .foregroundColor(.black.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                    Text(subtitle)
                        .foregroundColor(.black)
                }
                .font(.caption)
            }
            .padding(12)
            .background(
                Color.white
                    .opacity(0.8)
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .padding()
        }
        .frame(width: 200, height: 300)
    }
}

#Preview {
    FeaturedCardView(
        url: URL(string: "https://image.tmdb.org/t/p/w1280/z53D72EAOxGRqdr7KXXWp9dJiDe.jpg"),
        title: "Gunfire Ranger",
        subtitle: "Action  Character"
    )
}
