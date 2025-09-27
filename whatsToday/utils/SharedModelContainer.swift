//
//  SharedModelContainer.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 26/09/2025.
//

import Foundation
import SwiftData

struct SharedModelContainer {
    static var shared: ModelContainer = {
        let schema = Schema([
            Workout.self,
        ])
        
        let configuration = ModelConfiguration(
            "MyDataModel",
            schema: schema,
            groupContainer: .identifier("group.com.personalProject.whatsToday")
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            print("Failed to create shared ModelContainer: \(error.localizedDescription)")
            fatalError("Could not create shared ModelContainer: \(error)")
        }
    }()
}
