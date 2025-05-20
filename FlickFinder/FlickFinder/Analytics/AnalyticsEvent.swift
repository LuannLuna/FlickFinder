//
//  AnalyticsEvent.swift
//  FlickFinder
//
//  Created by Luann Luna on 19/05/25.
//

import Foundation

protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any] { get }
}

enum NavigationEvent: AnalyticsEvent {
    case screenView(route: Route)
    case tabChange(from: Tab, to: Tab)
    case backNavigation(from: Route, to: Route?)
    case deepLink(route: Route)
    
    var name: String {
        switch self {
        case .screenView:
            "screen_view"
        case .tabChange:
            "tab_change"
        case .backNavigation:
            "back_navigation"
        case .deepLink:
            "deep_link"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .screenView(let route):
            [
                "screen_name": route.title,
                "route_type": String(describing: type(of: route))
            ]
        case .tabChange(let from, let to):
            [
                "from_tab": from.label,
                "to_tab": to.label
            ]
        case .backNavigation(let from, let to):
            [
                "from_screen": from.title,
                "to_screen": to?.title ?? "root"
            ]
        case .deepLink(let route):
            [
                "route": route.title,
                "timestamp": Date().timeIntervalSince1970
            ]
        }
    }
} 
