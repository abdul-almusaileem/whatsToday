//
//  TodaysWorkout.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 27/09/2025.
//
import SwiftUI
import SwiftData


struct TodaysWorkout: View {
    
    
    
    @Binding private var selectedWorkout: Workout?
    @Binding private var detailsSheet: Bool
    
    private var upcomingWorkouts: [Workout]
    
    
    init(upcomingWorkouts: [Workout], detailsSheet: Binding<Bool>, selectedWorkout: Binding<Workout?>) {
        self.upcomingWorkouts = upcomingWorkouts;
        _detailsSheet = detailsSheet;
        _selectedWorkout = selectedWorkout
    }
    
    var body: some View {
        Text(upcomingWorkouts.count > 1 ? "Upcoming workouts" : "Upcoming workout")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundStyle(.accent)
            .padding()
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(upcomingWorkouts) { workout in
                    WorkoutCard(workout: workout)
                        .onTapGesture {
                            selectedWorkout = workout;
                            detailsSheet.toggle()
                        }
                        .fixedSize(horizontal: true, vertical: true)                        .padding()
                    
                }
            }
            
        }
        .scrollContentBackground(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 40)
        
        Divider()
    }
    
}

#Preview {
    @Previewable @State var myWorkout: Workout? = nil
    TodaysWorkout(upcomingWorkouts: [Workout(title: "long run", date: .now, type: WorkoutType.running, tags: ["test",], summary: "Test Run"),
                                     Workout(title: "t", date: .now, type: WorkoutType.cycling, tags: ["test",], summary: "Test Run")], detailsSheet: Binding.constant(false), selectedWorkout: $myWorkout)
    .environmentObject(ThemeManager())
}
