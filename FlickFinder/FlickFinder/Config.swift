//
//  Config.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

enum Config {
    static let apiKey = "081bb0fd84bbae6a1a5eaf3ebf0c5903"
    
    enum URLs {
        static let baseURL = "https://api.themoviedb.org/3"
        static let imageBaseURL = "https://image.tmdb.org/t/p"
    }
    
    enum ImageSize {
        static let poster = "w1280"
        static let backdrop = "original"
    }
} 
