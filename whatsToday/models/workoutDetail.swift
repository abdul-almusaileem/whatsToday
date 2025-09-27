//
//  workoutDetails.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 25/09/2025.
//

import Foundation
import SwiftData

@Model
final class WorkoutDetail {
    var warmup: String
    var blocks: [String]
    var coolDown: String?
    
    init(warmup: String, blocks: [String], coolDown: String? = nil) {
        self.warmup = warmup
        self.blocks = blocks
        self.coolDown = coolDown
    }
}
