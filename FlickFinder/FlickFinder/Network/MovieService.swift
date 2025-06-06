//
//  MovieService.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

@Observable
final class MovieService: MovieServiceProtocol {
    private let network: NetworkProtocol
    private let cache: CacheServiceProtocol

    init(network: NetworkProtocol, cache: CacheServiceProtocol = CacheService()) {
        self.network = network
        self.cache = cache
    }

    func fetchMovies(page: Int, genres: [Int], sortBy: String) async throws -> MovieResponse {
        var parameters: [String: Any] = [
            "page": page,
            "sort_by": sortBy
        ]

        if !genres.isEmpty {
            parameters["with_genres"] = genres.map(String.init).joined(separator: ",")
        }

        return try await network.fetch(
            from: "/discover/movie",
            with: parameters,
            responseType: MovieResponse.self
        )
    }
    
    func fetchPopularMovies(page: Int = 1) async throws -> MovieResponse {
        return try await network.fetch(
            from: "/movie/popular",
            with: ["page": page],
            responseType: MovieResponse.self
        )
    }
    
    func fetchNowPlayingMovies(page: Int = 1) async throws -> MovieResponse {
        return try await network.fetch(
            from: "/movie/now_playing",
            with: ["page": page],
            responseType: MovieResponse.self
        )
    }

    func fetchUpcomingMovies(page: Int = 1) async throws -> MovieResponse {
        return try await network.fetch(
            from: "/movie/upcoming",
            with: ["page": page],
            responseType: MovieResponse.self
        )
    }

    func fetchTopRatedMovies(page: Int = 1) async throws -> MovieResponse {
        return try await network.fetch(
            from: "/movie/top_rated",
            with: ["page": page],
            responseType: MovieResponse.self
        )
    }
}

#if DEBUG
extension NetworkService {
    static var preview: NetworkService {
        NetworkService(
            apiKey: Config.apiKey,
            cache: CacheService.preview
        )
    }
}

extension MovieService {
    static var preview: MovieService {
        MovieService(
            network: NetworkService.preview,
            cache: CacheService.preview
        )
    }
}
#endif
