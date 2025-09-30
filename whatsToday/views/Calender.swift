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
    @State private var sheetIsPresented: Bool = false
    
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]

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
                        .padding(.bottom, 50)
                    

                    CalendarViewRepresentable(workouts: workouts, selectedDate: $selectedDate)
                        .frame(height: 500)
                        .padding()
                    Spacer()
                }
                .onChange(of: selectedDate) { oldval, newValue in
                    if let newValue = newValue {
                        filteredWorkouts = workouts.filter {
                            $0.date.formatted(date: .numeric, time: .omitted) == newValue.formatted(date: .numeric, time: .omitted)
                        }
                    }
                    
                    if filteredWorkouts.count > 0 {
                        sheetIsPresented.toggle()
                    }
                    
                }
                .sheet(isPresented: $sheetIsPresented) {
                    WorkoutList(sheet: $sheetIsPresented, workouts: filteredWorkouts)
                }
            }
        }
               
        
        
    }
}

#Preview {
    Calender()
    

    
}
