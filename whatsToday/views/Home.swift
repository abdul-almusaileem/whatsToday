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
        NavigationStack {
            
            ZStack {
                Color.background.ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    if upcomingWorkouts.count > 0
                    {
                        TodaysWorkout(upcomingWorkouts: upcomingWorkouts, detailsSheet: $detailsSheet, selectedWorkout: $selectedWorkout)
                    }
                    
                    WorkoutList(selectedWorkout: $selectedWorkout, detailsSheet: $detailsSheet, searchText: $searchText, calanderSheet: $calanderSheet, workouts: workouts)
                }
                
                .backgroundStyle(themeManager.currentTheme.backgroundColor)
                .navigationBarTitle("Here's your Schedule")
                .foregroundStyle(.accent)
                .navigationBarTitleDisplayMode(.large)
                .scrollContentBackground(.hidden)
                .searchable(text: $searchText)
                
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "calendar")
                            .foregroundStyle(.accent)
                            .bold()
                            .onTapGesture{
                                calanderSheet.toggle()
                            }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            selectedWorkout = nil
                            detailsSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .foregroundStyle(.accent)
                                .bold()
                        }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $detailsSheet, content: {
                    Details(workout: selectedWorkout)
                })
                .sheet(isPresented: $calanderSheet, content: {
                    Calender();
                })
                .onAppear() {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(themeManager.currentTheme.accentColor))]
                }
                
            }
            
        }
        
    }
}

#Preview {
    Home()
        .modelContainer(for: [Workout.self, WorkoutDetail.self], inMemory: true)
        .environmentObject(ThemeManager())
    
    
}


