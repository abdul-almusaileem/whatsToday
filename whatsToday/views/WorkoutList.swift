//
//  WorkoutList.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 27/09/2025.
//
import SwiftUI
import SwiftData
import WidgetKit

struct WorkoutList: View {
    
    
    @Environment(\.modelContext) private var modelContext;
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) var dismiss
    
    
    @State private var detailsSheet: Bool = false
    @State private var selectedWorkout: Workout?
    private var workouts: [Workout]
    
    init(workouts: [Workout]) {
        self.workouts = workouts
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.background.ignoresSafeArea()
                List {
                    ForEach(workouts) { workout in
                        SmallWorkoutCard(workout: workout)
                            .padding()
                            .onTapGesture {
                                
                                selectedWorkout = workout;
                                detailsSheet.toggle()
                            }
                            .swipeActions(edge: .trailing) {
                                
                                Button(role: .destructive) {
                                    modelContext.delete(workout)
                                    if(Calendar.current.isDateInToday(workout.date)) {
                                        WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                                    }
                                    
                                } label: {
                                    Image(systemName: "trash")
                                }
                                Button {
                                    workout.isDone.toggle()
                                    try? modelContext.save()
                                } label: {
                                    Image(systemName: workout.isDone ? "xmark" :"checkmark")                                    }
                                .tint(workout.isDone ?  .gray: .accentColor)
                            }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .animation(.easeIn, value: workouts)
            }
            
            .sheet(item: $selectedWorkout) { workout in
                Details(workout: workout)
            }
            
            
        }
        
    }
}

#Preview {
    WorkoutList(workouts: [])
    
}

