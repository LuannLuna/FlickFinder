//
//  AnalyticsMiddleware.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

protocol AnalyticsMiddleware {
    func track(_ event: AnalyticsEvent)
}

final class AnalyticsManager: AnalyticsMiddleware {
    static let shared = AnalyticsManager()
    
    private var middlewares: [AnalyticsMiddleware] = []
    
    private init() {
        // Add default middlewares
        middlewares = [
            ConsoleAnalyticsMiddleware(),
            FirebaseAnalyticsMiddleware()
        ]
    }
    
    func addMiddleware(_ middleware: AnalyticsMiddleware) {
        middlewares.append(middleware)
    }
    
    func track(_ event: AnalyticsEvent) {
        middlewares.forEach { $0.track(event) }
    }
}

// MARK: - Middleware Implementations
final class ConsoleAnalyticsMiddleware: AnalyticsMiddleware {
    func track(_ event: AnalyticsEvent) {
        #if DEBUG
        print("📊 Analytics Event: \(event.name)")
        print("Parameters: \(event.parameters)")
        #endif
    }
}

final class FirebaseAnalyticsMiddleware: AnalyticsMiddleware {
    func track(_ event: AnalyticsEvent) {
        // TODO: Implement Firebase Analytics
        // This is a placeholder for Firebase Analytics implementation
    }
}

// MARK: - Preview Helpers
#if DEBUG
extension AnalyticsManager {
    static var preview: AnalyticsManager {
        let manager = AnalyticsManager()
        manager.middlewares = [ConsoleAnalyticsMiddleware()]
        return manager
    }
} 
#endif
