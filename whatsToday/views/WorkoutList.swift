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
                            .onTapGesture {
                                
                                selectedWorkout = workout;
                                detailsSheet.toggle()
                            }
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            modelContext.delete(workouts[index])
                            
                            if(Calendar.current.isDateInToday(workouts[index].date)) {
                                print("reloading widget")
                                WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                            }
                            
                            
                            
                        }
                        dismiss()
                    })
                }
                .scrollContentBackground(.hidden)
                .animation(.easeIn, value: workouts)
            }
            
            .sheet(isPresented: $detailsSheet) {
                
                // FIXME: selected workout is always nil
                //
                Details(workout: selectedWorkout)
            }
        }
        
    }
}

#Preview {
    WorkoutList(workouts: [])
        
}

