//
//  Home.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 24/09/2025.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.modelContext) private var modelContext;
    @EnvironmentObject var themeManager: ThemeManager
    
    
    @State private var detailsSheet = false
    @State private var calanderSheet = false
    @State private var selectedWorkout: Workout?
    @State private var searchText: String = ""
    
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    @Query(filter: Workout.nextWorkoutPredicate(), sort: \Workout.date, order: .reverse) private var upcomingWorkouts: [Workout]
    
    
    var nextWorkout: Workout? {
        upcomingWorkouts.first
    }
    
    var body: some View {
        TabView {
            TodaysWorkout()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
                Calender()
                .tabItem {
                    Image(systemName: "calendar")
                        .foregroundStyle(.accent)
                        .bold()
                }
            Search()
            .tabItem {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.accent)
                    .bold()
            }
            
        }
        
    }
    
}


#Preview {
    Home()
        .modelContainer(for: [Workout.self, WorkoutDetail.self], inMemory: true)
        .environmentObject(ThemeManager())
    
    
}


