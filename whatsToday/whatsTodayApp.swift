//
//  whatsTodayApp.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 23/09/2025.
//

import SwiftUI
import SwiftData

@main
struct whatsTodayApp: App {

    var body: some Scene {
        WindowGroup {
            Home();
        }
        .modelContainer(SharedModelContainer.shared)
        .environmentObject(ThemeManager())
    }
}

class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme = DarkTheme()
}

