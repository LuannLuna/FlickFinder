//
//  Item.swift
//  FlickFinder
//
//  Created by Luann Luna on 17/05/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
