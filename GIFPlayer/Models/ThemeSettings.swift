import SwiftUI

enum Theme: String, CaseIterable {
    case system = "Sistem"
    case light = "Açık"
    case dark = "Koyu"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var icon: String {
        switch self {
        case .system:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
}

class ThemeSettings: ObservableObject {
    @AppStorage("selectedTheme") private var storedTheme: String = Theme.system.rawValue
    
    @Published var selectedTheme: Theme {
        didSet {
            storedTheme = selectedTheme.rawValue
        }
    }
    
    init() {
        self.selectedTheme = Theme(rawValue: storedTheme) ?? .system
    }
    
    var isDarkMode: Bool {
        switch selectedTheme {
        case .system:
            return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        case .light:
            return false
        case .dark:
            return true
        }
    }
    
    var backgroundColor: Color {
        isDarkMode ? Color(NSColor.windowBackgroundColor) : .white
    }
    
    var textColor: Color {
        isDarkMode ? .white : .black
    }
    
    var secondaryBackgroundColor: Color {
        isDarkMode ? Color(NSColor.controlBackgroundColor) : Color(NSColor.controlBackgroundColor)
    }
} 