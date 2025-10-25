//
//  whatsTodayWidget.swift
//  whatsTodayWidget
//
//  Created by Abdulrahman Almusaileem on 26/09/2025.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

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
    
}

@MainActor
func getTodaysWorkout() -> [Workout] {
    let modelContainer = SharedModelContainer.shared
    let descriptor = FetchDescriptor<Workout>(
        predicate: Workout.widgetWorkoutPredicate(),
        sortBy: [
            .init(\.date)
        ]
    )
    
    let workouts: [Workout]? = try? modelContainer.mainContext.fetch(descriptor)
    
    return workouts ?? []
    
}


struct ButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "My Widget Button Intent"
    @Parameter(title:"workoutId")
    var id: String
    
    
    
    init(id: String) {
        self.id = id
    }
    init() {
        
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let workouts = getTodaysWorkout()
        
        guard let index = workouts.firstIndex(where: { $0.id.uuidString == id }) else {
            return .result()
        }
        let updatedWorkout = workouts[index]
        updatedWorkout.isDone.toggle()
        await MainActor.run {
            let context = SharedModelContainer.shared.mainContext
            try? context.save()
        }
        
        return .result()
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let workout: [Workout]
}

struct whatsTodayWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            VStack {
                if entry.workout.isEmpty {
                    Text("Take it easy and recharge.")
                        .foregroundStyle(.accent)
                        .bold()
                }
                ForEach(entry.workout){ workout in
                    VStack (alignment: .leading) {
                        HStack {
//                            AppIntentButton(intent: ButtonIntent(id: workout.id.uuidString)) {
//                                Label("Toggle Done", systemImage: workout.isDone ? "checkmark.circle.fill" : "circle")
//                            }
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
        .containerBackground(Color.background, for: .widget)
        
        
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
    SimpleEntry(date: .now, workout: [])
}


