import SwiftUI

struct MovieGrid: View {
    // MARK: - Properties
    let title: String
    let movies: [Movie]
    let onMovieTap: (Movie) -> Void
    let cardSize: MoviePosterCard.Size
    
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !movies.isEmpty {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(themeManager.textColor)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(movies.prefix(10)) { movie in
                            MoviePosterCard(
                                movie: movie,
                                size: cardSize,
                                onTap: { onMovieTap(movie) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Preview
#if DEBUG

struct MovieGrid_Previews: PreviewProvider {
    static var previews: some View {
        let movies = Array(
            repeating: Movie(
                id: 1,
                title: "Sample Movie",
                overview: "This is a sample movie overview.",
                posterPath: "/sample.jpg",
                backdropPath: nil,
                voteAverage: 8.5,
                voteCount: 1000,
                releaseDate: "2023-01-01",
                popularity: 100.0,
                originalTitle: "Sample Movie",
                originalLanguage: "en",
                genreIds: [1, 2, 3],
                adult: false,
                video: false
            ),
            count: 5
        )
        
        MovieGrid(
            title: "Popular Movies",
            movies: movies,
            onMovieTap: { _ in },
            cardSize: .medium
        )
        .previewLayout(.sizeThatFits)
        .environmentObject(ThemeManager.shared)
    }
}
#endif
