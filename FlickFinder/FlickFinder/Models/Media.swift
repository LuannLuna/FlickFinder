import Foundation

// MARK: - Welcome10
struct MediaResponse: Codable {
    let page: Int
    let results: [Media]
    let totalPages, totalResults: Int
}

// MARK: - Result
struct Media: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
}
