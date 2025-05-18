//
//  Movie.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let releaseDate: String
    let popularity: Double
    let originalTitle: String
    let originalLanguage: String
    let genreIds: [Int]
    let adult: Bool
    let video: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case releaseDate = "release_date"
        case popularity
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case genreIds = "genre_ids"
        case adult
        case video
    }
    
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w1280\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)")
    }
}
