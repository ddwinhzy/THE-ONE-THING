//
//  Item.swift
//  The One Thing
//
//  Created by ZHIWEN HUANG on 7/10/25.
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
