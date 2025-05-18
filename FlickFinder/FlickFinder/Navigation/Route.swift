//
//  Route.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation

enum Route: Hashable {
    case movieDetail(Movie)
    case search(String)
    case profile
    case settings
    case watchlist
    case favorites
    
    var title: String {
        switch self {
        case .movieDetail:
            "Movie Details"
        case .search:
            "Search"
        case .profile:
            "Profile"
        case .settings:
            "Settings"
        case .watchlist:
            "Watchlist"
        case .favorites:
            "Favorites"
        }
    }
} 