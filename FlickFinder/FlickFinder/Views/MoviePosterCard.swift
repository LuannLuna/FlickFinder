import SwiftUI

struct MoviePosterCard: View {
    // MARK: - Properties
    let movie: Movie
    let size: Size
    let onTap: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager

    // MARK: - Size
    enum Size {
        case small, medium, large, extraLarge

        var width: CGFloat {
            switch self {
                case .small: return 100
                case .medium: return 120
                case .large: return 150
                case .extraLarge: return 180
            }
        }

        var height: CGFloat {
            width * 1.5
        }

        var titleFont: Font {
            switch self {
                case .small: return .caption2
                case .medium: return .caption
                case .large: return .subheadline
                case .extraLarge: return .headline
            }
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            posterImage
                .onTapGesture(perform: onTap)
            
            if size != .small {
                movieTitle
            }
        }
        .frame(width: size.width)
    }
    
    // MARK: - Subviews
    private var posterImage: some View {
        AsyncImage(url: posterURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure(_):
                placeholderImage
            case .empty:
                placeholderImage
            @unknown default:
                placeholderImage
            }
        }
        .frame(width: size.width, height: size.height)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(radius: 4)
    }
    
    private var movieTitle: some View {
        Text(movie.title)
            .font(size.titleFont)
            .fontWeight(.semibold)
            .foregroundColor(themeManager.textColor)
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var placeholderImage: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: "film")
                .foregroundColor(.gray)
        }
    }
    
    // MARK: - Helper
    private var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
}

// MARK: - Preview
#if DEBUG
struct MoviePosterCard_Previews: PreviewProvider {
    static var previews: some View {
        let movie = Movie(
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
        )
        
        VStack {
            MoviePosterCard(movie: movie, size: .small, onTap: {})
            MoviePosterCard(movie: movie, size: .medium, onTap: {})
            MoviePosterCard(movie: movie, size: .large, onTap: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .environmentObject(ThemeManager.shared)
    }
}
#endif
