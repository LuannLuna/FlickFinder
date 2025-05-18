//
//  CacheService.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

protocol CacheServiceProtocol {
    func cache<T: Codable>(_ object: T, for key: String) throws
    func object<T: Codable>(for key: String) throws -> T?
    func removeObject(for key: String)
    func clearCache()
}

final class CacheService: CacheServiceProtocol {
    private let storage: UserDefaults
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let expirationInterval: TimeInterval
    
    init(
        storage: UserDefaults = .standard,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init(),
        expirationInterval: TimeInterval = 3600 // 1 hour default
    ) {
        self.storage = storage
        self.encoder = encoder
        self.decoder = decoder
        self.expirationInterval = expirationInterval
    }
    
    private struct CacheEntry<T: Codable>: Codable {
        let value: T
        let timestamp: Date
        
        var isExpired: Bool {
            Date().timeIntervalSince(timestamp) > 3600 // 1 hour
        }
    }
    
    func cache<T: Codable>(_ object: T, for key: String) throws {
        let entry = CacheEntry(value: object, timestamp: Date())
        let data = try encoder.encode(entry)
        storage.set(data, forKey: key)
    }
    
    func object<T: Codable>(for key: String) throws -> T? {
        guard let data = storage.data(forKey: key) else { return nil }
        let entry = try decoder.decode(CacheEntry<T>.self, from: data)
        
        guard !entry.isExpired else {
            removeObject(for: key)
            return nil
        }
        
        return entry.value
    }
    
    func removeObject(for key: String) {
        storage.removeObject(forKey: key)
    }
    
    func clearCache() {
        let dictionary = storage.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            storage.removeObject(forKey: key)
        }
    }
}

#if DEBUG
extension CacheService {
    static var preview: CacheService {
        CacheService(expirationInterval: 300) // 5 minutes for preview
    }
} 
#endif
