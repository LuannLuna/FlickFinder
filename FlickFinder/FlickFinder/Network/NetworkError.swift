//
//  NetworkError.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .invalidResponse:
            "Invalid response from server"
        case .invalidData:
            "Invalid data received"
        case .unknown(let error):
            error.localizedDescription
        }
    }
} 