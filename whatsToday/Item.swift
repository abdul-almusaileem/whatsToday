//
//  Item.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 23/09/2025.
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
