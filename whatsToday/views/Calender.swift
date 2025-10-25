//
//  Calender.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 24/09/2025.
//

import SwiftUI
import SwiftData


struct Calender: View {
    @State private var selectedDate: Date?
    @State private var filteredWorkouts: [Workout] = []
    @State private var selectedWorkout: Workout?
    
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    
    var workoutsThisMonth: [Workout] {
        let calendar = Calendar.current
        var customCalendar = calendar
        let dateToUse = selectedDate ?? Date()
        customCalendar.firstWeekday = 1
        
        return workouts.filter { workout in
            customCalendar.isDate(workout.date, equalTo: dateToUse, toGranularity: .month) &&
            customCalendar.isDate(workout.date, equalTo: dateToUse, toGranularity: .year)
        }
    }
    var finishedThisMonth: [Workout] {
        workoutsThisMonth.filter { workout in
            workout.isDone
        }
    }
    var workoutsThisWeek: [Workout] {
        let calendar = Calendar.current
        var customCalendar = calendar
        let dateToUse = selectedDate ?? Date()
        customCalendar.firstWeekday = 1
        
        return workouts.filter { workout in
            customCalendar.isDate(workout.date, equalTo: dateToUse, toGranularity: .weekOfYear) &&
            customCalendar.isDate(workout.date, equalTo: dateToUse, toGranularity: .year)
        }
    }
    var finishedThisWeek: [Workout] {
        workoutsThisWeek.filter { workout in
            workout.isDone
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.opacity(1).ignoresSafeArea()
                
                VStack {
                    Text("Planned sessions")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .padding()
                    
                    HStack{
                        Text("Month:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                            .padding(.bottom, 50)
                        
                        Text("\(finishedThisMonth.count)/\(workoutsThisMonth.count)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                            .padding()
                            .padding(.bottom, 50)
                        
                        Text("Week:")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                            .padding(.bottom, 50)
                        
                        Text("\(finishedThisWeek.count)/\(workoutsThisWeek.count)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.text)
                            .padding()
                            .padding(.bottom, 50)
                    }
                    
                    CalendarViewRepresentable(workouts: workouts, selectedDate: $selectedDate)
                        .frame(height: 400)
                    Spacer()
                }
                .onChange(of: selectedDate) { oldval, newValue in
                    
                    if let newValue = newValue {
                        filteredWorkouts = workouts.filter {
                            $0.date.formatted(date: .numeric, time: .omitted) == newValue.formatted(date: .numeric, time: .omitted)
                        }
                    }
                    
                    if let firstWorkout = filteredWorkouts.first{
                            selectedWorkout = firstWorkout;
                    }
                }
                
                .sheet(item: $selectedWorkout) { _ in
                    WorkoutList(workouts: filteredWorkouts)
                }
            }
        }
    }
}

#Preview {
    Calender()
}
