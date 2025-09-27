//
//  whatsTodayWidget.swift
//  whatsTodayWidget
//
//  Created by Abdulrahman Almusaileem on 26/09/2025.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: @preconcurrency TimelineProvider {
    @MainActor func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), workout: getTodaysWorkout())
    }
    
    @MainActor func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), workout: getTodaysWorkout())
        completion(entry)
    }
    
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = SimpleEntry(date: .now, workout: getTodaysWorkout())
        let calendar = Calendar.current
        let now = Date()
        let startOfTomorrow = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60) //24 * 60 * 60
        let timeline = Timeline(entries: [entry], policy: .after(startOfTomorrow))
        completion(timeline)
    }
    
    @MainActor
    private func getTodaysWorkout() -> [Workout] {
        let modelContainer = SharedModelContainer.shared
        let descriptor = FetchDescriptor<Workout>(
            predicate: Workout.nextWorkoutPredicate(),
            sortBy: [
                .init(\.date)
            ]
        )
        
        let workouts: [Workout]? = try? modelContainer.mainContext.fetch(descriptor)
        
        print(workouts!)
        
        return workouts ?? []
        
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let workout: [Workout]
}

struct whatsTodayWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            if entry.workout.isEmpty {
                Text("Nothing planned for today")
                    .foregroundStyle(.accent)
                    .bold()
            }
            ForEach(entry.workout){ workout in
                VStack (alignment: .leading) {
                    HStack {
                        Text(workout.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(.accent)
                        
                        Spacer()
                        
                        Text(workout.type.rawValue)
                            .foregroundStyle(.text)
                            .font(.caption)
                    }
                    Text(workout.summary)
                        .foregroundStyle(.text)
                        .font(.caption2)
                        .lineLimit(4)
                    Divider()
                }
            }
        }
        
        
    }
}

struct whatsTodayWidget: Widget {
    let kind: String = "whatsTodayWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            whatsTodayWidgetEntryView(entry: entry)
                .containerBackground(.fill, for: .widget)
        }
        .configurationDisplayName("Next Workout")
        .description("This widget shows your next workout.")
    }
}

#Preview(as: .systemSmall) {
    whatsTodayWidget()
} timeline: {
    SimpleEntry(date: .now, workout: [Workout(title: "long run", date: .now, type: WorkoutType.running, tags: ["test",], summary: "Test Run"),
                                      Workout(title: "ride", date: .now, type: WorkoutType.cycling, tags: ["test",], summary: "Test Run")])
}


