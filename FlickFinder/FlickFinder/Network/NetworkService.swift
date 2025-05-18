//
//  NetworkService.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

final class NetworkService: NetworkProtocol {
    private let baseURL: String
    private let apiKey: String
    private let session: URLSession
    private let decoder: JSONDecoder
    private let cache: CacheServiceProtocol
    private let maxRetries: Int
    
    init(
        baseURL: String = "https://api.themoviedb.org/3",
        apiKey: String,
        session: URLSession = .shared,
        decoder: JSONDecoder = .init(),
        cache: CacheServiceProtocol = CacheService(),
        maxRetries: Int = 3
    ) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.session = session
        self.decoder = decoder
        self.cache = cache
        self.maxRetries = maxRetries
    }
    
    func fetch<T: Codable>(
        from endpoint: String,
        with parameters: [String: Any],
        responseType: T.Type
    ) async throws -> T {
        let cacheKey = generateCacheKey(endpoint: endpoint, parameters: parameters)
        
        // Try to get from cache first
        if let cachedObject: T = try? cache.object(for: cacheKey) {
            return cachedObject
        }
        
        // If not in cache, fetch from network with retry
        return try await fetchWithRetry(
            endpoint: endpoint,
            parameters: parameters,
            responseType: responseType,
            cacheKey: cacheKey,
            retriesLeft: maxRetries
        )
    }
    
    private func fetchWithRetry<T: Codable>(
        endpoint: String,
        parameters: [String: Any],
        responseType: T.Type,
        cacheKey: String,
        retriesLeft: Int
    ) async throws -> T {
        do {
            let components = try urlComponents(for: endpoint, with: parameters)
            guard let url = components.url else {
                throw NetworkError.invalidURL
            }
            
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            let decodedObject = try decoder.decode(responseType, from: data)
            
            // Cache successful response
            try? cache.cache(decodedObject, for: cacheKey)
            
            return decodedObject
        } catch {
            if retriesLeft > 0 {
                // Add exponential backoff delay
                let delay = Double(maxRetries - retriesLeft + 1) * 0.5
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                
                return try await fetchWithRetry(
                    endpoint: endpoint,
                    parameters: parameters,
                    responseType: responseType,
                    cacheKey: cacheKey,
                    retriesLeft: retriesLeft - 1
                )
            } else {
                throw error
            }
        }
    }
    
    private func urlComponents(for endpoint: String, with parameters: [String: Any]) throws -> URLComponents {
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        components.queryItems = queryItems
        return components
    }
    
    private func generateCacheKey(endpoint: String, parameters: [String: Any]) -> String {
        let sortedParams = parameters.sorted { $0.key < $1.key }
        let paramsString = sortedParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        return "\(endpoint)?\(paramsString)"
    }
}
