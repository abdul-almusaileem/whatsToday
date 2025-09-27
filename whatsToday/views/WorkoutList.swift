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
    
    @Binding private var selectedWorkout: Workout?
    @Binding private var detailsSheet: Bool
    @Binding private var searchText: String
    @Binding private var calanderSheet: Bool
    private var workouts: [Workout]
    
    private var filteredWorkouts: [Workout]  {
        if (searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            return workouts;
        }
        else {
            return workouts.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.tags.contains(searchText.lowercased())
            }
        }
    }
    
    init(selectedWorkout: Binding<Workout?>, detailsSheet: Binding<Bool>, searchText: Binding<String>, calanderSheet: Binding<Bool>, workouts: [Workout]) {
        _selectedWorkout = selectedWorkout
        _detailsSheet = detailsSheet
        _searchText = searchText
        _calanderSheet = calanderSheet
        self.workouts = workouts
    }
    
    
    var body: some View {
        List {
            ForEach(filteredWorkouts) { workout in
                SmallWorkoutCard(workout: workout)
                    .onTapGesture {
                        selectedWorkout = workout;
                        detailsSheet.toggle()
                    }
//                    .frame(width: , height: 100)
                
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    modelContext.delete(workouts[index])
                    
                    if(Calendar.current.isDateInToday(workouts[index].date)) {
                        print("reloading widget")
                        WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                    }
                }
            })
        }
        .animation(.easeIn, value: filteredWorkouts)
        
    }
}

