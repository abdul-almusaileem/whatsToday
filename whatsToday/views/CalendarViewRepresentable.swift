//
//  CalendarViewRepresentable.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 28/09/2025.
//
import UIKit
import SwiftUI


struct CalendarViewRepresentable: UIViewRepresentable {
    
    private var workouts: [Workout]
    @Binding private var selectedDate: Date?

    
    init(workouts: [Workout], selectedDate: Binding<Date?>) {
        self.workouts = workouts;
        _selectedDate = selectedDate;
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar(identifier: .gregorian)
        calendarView.locale = Locale.current
        calendarView.fontDesign = .rounded
        
        
        calendarView.delegate = context.coordinator
        
        
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Coordinator class to handle delegate methods
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            let customView = UILabel()
            for workout in parent.workouts {
                customView.text = "\(workout.type.rawValue)"
                if dateComponents.date?.formatted(date: .numeric, time: .omitted) == workout.date.formatted(date: .numeric, time: .omitted) {
                    return .default(color: .accent)
                }
            }
            
            
            return nil
        }
        
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            // Convert DateComponents to Date and update the SwiftUI binding
//            
            parent.selectedDate = dateComponents?.date
            
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            // Return true to allow selection for a specific date
            return true
        }
    }
}
