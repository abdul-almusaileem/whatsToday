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
    
    @Environment(\.modelContext) private var modelContext;
    @Query(filter: Workout.nextWorkoutPredicate(), sort: \Workout.date, order: .reverse) private var upcomingWorkouts: [Workout]
    
    
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.opacity(1).ignoresSafeArea()
                VStack {
                    Text(upcomingWorkouts.count > 1 ? "Upcoming workouts" : "Upcoming workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .padding()
                    
                    List {
                        ForEach(upcomingWorkouts) { workout in
                            WorkoutCard(workout: workout)
                                .onTapGesture {
                                    selectedWorkout = workout;
                                    detailsSheet.toggle()
                                }
                                .padding()
                            
                        }
                        .onDelete(perform: { indexSet in
                            for index in indexSet {
                                modelContext.delete(upcomingWorkouts[index])
                                
                                if(Calendar.current.isDateInToday(upcomingWorkouts[index].date)) {
                                    print("reloading widget")
                                    WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                                }
                            }
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .animation(.easeIn, value: upcomingWorkouts)
                    
                    
                    
                    Button(action: {
                        selectedWorkout = nil;
                        detailsSheet.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                    Spacer()
                    
                        .sheet(isPresented: $detailsSheet) {
                            Details(workout: selectedWorkout)
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
