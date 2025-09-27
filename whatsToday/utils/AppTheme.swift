//
//  AppTheme.swift
//  whatsToday
//
//  Created by Abdulrahman Almusaileem on 25/09/2025.
//
import SwiftUI

protocol AppTheme {
    var backgroundColor: Color { get }
    var textColor: Color { get }
    var accentColor: Color { get }
    var headlineFont: Font { get }
    var opacity: Double { get }
}

// The Dark Theme
struct DarkTheme: AppTheme {
    var opacity: Double {
        return 0.5
    }
    
    var textColor: Color {
        return .text
    }
    var accentColor: Color {
        return .accentColor
    }
    var headlineFont: Font {
        Font.caption.bold()
    }
    var backgroundColor: Color {
        return .background
    }
}

// The Light Theme
struct LightTheme: AppTheme {
    var opacity: Double {
        return 0.5
    }
    
    var textColor: Color {
        return .text
    }
    var accentColor: Color {
        return .accentColor
    }
    var headlineFont: Font {
        Font.caption.bold()
    }
    var backgroundColor: Color {
        return .background
    }
}
