//
//  Search.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 29/09/2025.
//

import SwiftUI
import SwiftData
import WidgetKit

struct Search: View {
    
    
    @Environment(\.modelContext) private var modelContext;
    @Query(sort: \Workout.date, order: .reverse) private var workouts: [Workout]
    
    @State private var searchText: String = ""
    @State private var detailsSheet: Bool = false
    @State private var selectedWorkout: Workout?
    
    private var filteredWorkouts: [Workout] {
        return workouts.filter {
            $0.title.lowercased().contains(searchText.lowercased())
            ||
            $0.tags.joined(separator: " ").contains(searchText.lowercased())
            ||
            $0.summary.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            Text("Search")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.accent)
                .padding()
                .padding(.bottom, 50)
            
            Spacer()
            List {
                ForEach(filteredWorkouts) { workout in
                    WorkoutCard(workout: workout)
                        .onTapGesture {
                            selectedWorkout = workout;
                            detailsSheet.toggle()
                        }
                        .padding()
                    
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        modelContext.delete(filteredWorkouts[index])
                        
                        if(Calendar.current.isDateInToday(filteredWorkouts[index].date)) {
                            print("reloading widget")
                            WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                        }
                    }
                })
            }
            .scrollContentBackground(.hidden)
            .animation(.easeIn, value: filteredWorkouts)
            
            
            
            
                .searchable(text: $searchText, prompt: "Search workouts, tags")
                .sheet(isPresented: $detailsSheet) {
                    Details(workout: selectedWorkout)
                }
                    
        }
    }
}

#Preview {
    Search()
        
}
