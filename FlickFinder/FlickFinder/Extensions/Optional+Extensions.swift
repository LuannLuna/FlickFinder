//
//  Optional+Extensions.swift
//  FlickFinder
//
//  Created by Luann Luna on 03/06/25.
//

import Foundation

extension Optional {
    var isNil: Bool { self == nil }

    var isNotNil: Bool { self != nil }
}
