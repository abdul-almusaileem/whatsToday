//
//  Workout.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 24/09/2025.
//

import Foundation
import SwiftData

@Model
final class Workout: Identifiable, Equatable {
    @Attribute(.unique)
    var id: UUID
    var title: String
    var summary: String
    var date: Date
    var type: WorkoutType
    var tags: [String]
    var workoutDetails: WorkoutDetail?
    var isDone: Bool = false
    
    
    init(title: String, date: Date, type: WorkoutType, tags: [String], summary: String = "") {
        self.id = UUID();
        self.title = title;
        self.type = type;
        self.tags = tags;
        self.date = date;
        self.summary = summary;
    }
    
}

extension Workout {
    static func sample() -> Self {
        .init(title: "Running", date: Date(), type: .running, tags: [])
    }
    static func newWorkout() -> Self {
        .init(title: "", date: Date(), type: .running, tags: [])
    }
    static func nextWorkoutPredicate() -> Predicate<Workout> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        
        return #Predicate<Workout> { workout in
            workout.date >= startOfToday && workout.date < endOfToday
        }
        
    }
    static func widgetWorkoutPredicate() -> Predicate<Workout> {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        let endOfToday = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        
        return #Predicate<Workout> { workout in
            workout.date >= startOfToday && workout.date < endOfToday
            && workout.isDone == false
        }
        
    }
}
