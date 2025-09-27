//
//  Details.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 24/09/2025.
//
import SwiftUI
import WidgetKit

struct Details: View {
    // The workout object to be edited. It's an optional.
    var workout: Workout?
    
    // Local @State variables to hold the form data.
    @State private var title: String
    @State private var date: Date
    @State private var summary: String
    @State private var newTag: String = "";
    @State private var tags: [String]
    @State private var type: WorkoutType
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    
    
    private var viewModel: WorkoutViewModel {
        WorkoutViewModel(modelContext: modelContext)
    }
    
    init(workout: Workout?) {
        self.workout = workout
        _title = State(initialValue: workout?.title ?? "")
        _date = State(initialValue: workout?.date ?? Date())
        _summary = State(initialValue: workout?.summary ?? "")
        _type = State(initialValue: workout?.type ?? .other)
        _tags = State(initialValue: workout?.tags ?? [])
    }
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.background.ignoresSafeArea()
                VStack(spacing: 20) {
                    HStack {
                        Text("Workout Type")
                            .font(.headline)
                            .foregroundStyle(.text)
                            .foregroundStyle(.accent)
                        Spacer()
                        Picker("Type", selection: $type) {
                            ForEach(WorkoutType.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Title")
                            .font(.headline)
                            .foregroundStyle(.text)
                        TextField("e.g. Morning Run", text: $title)
                            .textFieldStyle(.roundedBorder)
                            .background(Color.background.opacity(0.2)) // TODO: FIX THIS
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Text("Date")
                            .font(.headline)
                            .foregroundStyle(.text)
                        Spacer()
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .labelsHidden()
                            .tint(.accent)
                        
                        
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Summary")
                            .font(.headline)
                            .foregroundStyle(.text)
                        TextField("Descripe the workout", text: $summary, axis: .vertical)
                            .lineLimit(3...5)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    .padding(.horizontal)
                    
                    Divider()
                    
                    VStack{
                        Text("Tags")
                            .font(.headline)
                            .padding(.horizontal)
                            .foregroundStyle(.text)
                        
                        HStack {
                            TextField("Enter a tag", text: $newTag)
                                .textFieldStyle(.roundedBorder)
                                .autocorrectionDisabled(true)
                                .onSubmit { addTag() }
                            Spacer()
                            Button(action: {
                                addTag()
                            }) {
                                Image(systemName: "plus.circle.fill")
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    HStack {
                                        Text(tag)
                                            .foregroundStyle(.text)
                                        Spacer()
                                        Button(action: {
                                            removeTag(tag)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red).opacity(0.6)
                                        }
                                    }
                                    .padding(5)
                                    .background(Color.accentColor.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    
                    Button(action: {
                        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            print("select a title")
                            return
                        }
                        if let workout = workout {
                            workout.title = title
                            workout.date = date
                            workout.type = type
                            workout.tags = tags
                            workout.summary = summary
                        }
                        else {
                            let workout = Workout(title: title, date: date, type: type, tags: tags, summary: summary)
                            modelContext.insert(workout)
                        }
                        
                        dismiss()
                    }) {
                        Text("Save")
                            .foregroundStyle(.text)
                        
                    }
                    .padding([.top, .horizontal])
                }
                .padding(.vertical, 20)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .navigationTitle(workout?.title ?? "New Workout")
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color(themeManager.currentTheme.accentColor))]
                }
                .onDisappear() {
                    
                    // if today's date then update widget
                    //
                    if(Calendar.current.isDateInToday(date)) {
                        print("reloading widget")
                        WidgetCenter.shared.reloadTimelines(ofKind: "whatsTodayWidget")
                    }
                }
            }
        }
        
    }
    private func addTag() {
        let trimmed = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
        tags.append(trimmed.lowercased())
        newTag = ""
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
}

#Preview {
    Details(workout:nil)
        .modelContainer(for: Workout.self, inMemory: true)
        .environmentObject(ThemeManager())
}
