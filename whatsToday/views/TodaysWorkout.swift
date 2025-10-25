//
//  TodaysWorkout.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 27/09/2025.
//
import SwiftUI
import SwiftData
import WidgetKit


struct TodaysWorkout: View {
    
    @State private var selectedWorkout: Workout?
    @State private var detailsSheet: Bool = false
    @State private var isNewWorkout = false;
    
    @Environment(\.modelContext) private var modelContext;
    @Query(filter: Workout.nextWorkoutPredicate(), sort: \Workout.date, order: .reverse) private var upcomingWorkouts: [Workout]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.ignoresSafeArea()
                VStack {
                    Text(upcomingWorkouts.count > 1 ? "Today's sessions" : "Today's session")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .padding()
                    
                    List {
                        ForEach(upcomingWorkouts) { workout in
                            WorkoutCard(workout: workout)
                                .onTapGesture {
                                    selectedWorkout = workout;
                                }
                                .padding()
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
                                        if(Calendar.current.isDateInToday(workout.date)) {
                                            WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                                        }
                                    } label: {
                                        Image(systemName: workout.isDone ? "xmark" :"checkmark")                                    }
                                    .tint(workout.isDone ?  .gray: .accentColor)
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .animation(.easeIn, value: upcomingWorkouts)
                    
                    
                    
                    Button(action: {
                        DispatchQueue.main.async {
                            isNewWorkout = true
                            selectedWorkout = Workout.newWorkout()
                        }
                        
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                    Spacer()
                        .sheet(item: $selectedWorkout) { workout in
                            if isNewWorkout {
                                Details(workout: workout, isEditable: false)

                            }
                            else {
                                Details(workout: workout, isEditable: true)

                            }
                        }
                }
            }
        }
    }
}


#Preview {
    TodaysWorkout()
        .environmentObject(ThemeManager())
}
