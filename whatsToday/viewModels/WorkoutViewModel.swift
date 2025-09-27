//
//  WorkoutViewModel.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 25/09/2025.
//


//
//  Workout.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 24/09/2025.
//

import Foundation
import SwiftUICore
import SwiftData

@Observable
class WorkoutViewModel {
    
    var workouts: [Workout] = []
    private let modelContext: ModelContext
    
    
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addWorkout(title:String, date:Date, type:WorkoutType, tags:[String], details: WorkoutDetail? = nil, summary:String = "") {
        var workout =  Workout.init(title: title, date: date, type: type, tags: tags);
        if details != nil {
            workout.workoutDetails = details;
        }
        modelContext.insert(workout)
        fetchWorkouts();
    }
    
    func fetchWorkouts(){
        do {
            let fetchDiscriptor = FetchDescriptor<Workout>(
                sortBy: [SortDescriptor(\.date)]
            )
            workouts = try modelContext.fetch(fetchDiscriptor);
        }
        catch {
            print("Error fetching workouts: \(error)")
            workouts = []
        }
    }
    
    func filterWorkoutsByTag(_ tag: String) -> [Workout] {
        return workouts.filter { $0.tags.contains(tag)};
    }
    
    func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout);
        fetchWorkouts();
    }
    
    func editWorkout(workout: Workout, title: String, date: Date, type: WorkoutType, tags: [String], details: WorkoutDetail?, summary: String = "") {
        do {
            workout.title = title;
            workout.date = date;
            workout.type = type;
            workout.tags = tags;
            workout.summary = summary;
            
            if let details = details {
                workout.workoutDetails = details;
            }
            try modelContext.save();
            fetchWorkouts();
        }
        catch {
            print("Error, unable to save workout: \(error)")
        }
    }
    

}
