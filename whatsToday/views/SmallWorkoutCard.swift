//
//  SmallWorkoutCard.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 27/09/2025.
//

import SwiftUI

struct SmallWorkoutCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    var workout: Workout
    var body: some View {
        VStack{
            HStack{
                Text(workout.title)
                    .font(.title2.bold())
                    .foregroundStyle(.accent)
                    .minimumScaleFactor(0.5)
                Spacer()
                Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                    .opacity(themeManager.currentTheme.opacity)
                    .foregroundStyle(.text)
                
            }.padding([.leading, .trailing], 20).padding([.top])
            HStack{
                HStack {
                    Spacer()
                    ForEach(workout.tags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .padding(.horizontal)
                            .foregroundStyle(.text)
                            .opacity(themeManager.currentTheme.opacity)
                            .background(Color.accentColor.opacity(0.2))
                            .cornerRadius(8)
                            .lineLimit(1)
                    }
                    
                    if (workout.tags.count > 3) {
                        Text("...")
                            .foregroundStyle(.text)
                            .padding(-2)
                    }
                    Spacer()
                }
                .frame(maxWidth: 500)
                .padding(.trailing, 20)
                
                Spacer()
                HStack {
                    Text(workout.type.rawValue)
                        .opacity(themeManager.currentTheme.opacity)
                        .foregroundStyle(.text)
                        .lineLimit(1)
                }
                .fixedSize()
                
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom])
            
            
        }
        .padding(5)
        .background(themeManager.currentTheme.backgroundColor)
        .cornerRadius(20)
        .shadow(
            color: colorScheme == .dark
                ? Color.white.opacity(0.1)
                : Color.black.opacity(0.2),
            radius: 5, x: 0, y: 3
        )
        .listRowBackground(Color.clear)
        .containerRelativeFrame(.horizontal) { length, axis in
            length * 0.9
        }
        
    }
}

#Preview {
    var workout = Workout(title: "Long Run", date: Date(), type: WorkoutType.running, tags: ["long", "run", "distance", "fitness", "exercise"])
    workout.summary = "This is a long run\n test"
    
    return SmallWorkoutCard(workout: workout)
        .environmentObject(ThemeManager())
}
