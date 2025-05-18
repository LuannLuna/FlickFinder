//
//  NetworkProtocol.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

protocol NetworkProtocol {
    func fetch<T: Codable>(from endpoint: String, with parameters: [String: Any], responseType: T.Type) async throws -> T
}

protocol MovieServiceProtocol {
    func fetchMovies(page: Int, genres: [Int], sortBy: String) async throws -> MovieResponse
}

extension MovieServiceProtocol {
    func fetchMovies(page: Int = 1, genres: [Int] = [], sortBy: String = "popularity.desc") async throws -> MovieResponse {
        try await fetchMovies(
            page: page,
            genres: genres,
            sortBy: sortBy
        )
    }
}
