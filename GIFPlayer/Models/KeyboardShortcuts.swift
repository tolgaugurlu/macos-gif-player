import SwiftUI

enum KeyboardShortcut: String {
    case playPause = "space"
    case nextFrame = "rightArrow"
    case previousFrame = "leftArrow"
    case increaseSpeed = "upArrow"
    case decreaseSpeed = "downArrow"
    case toggleLoop = "l"
    case openFile = "o"
    
    var key: KeyEquivalent {
        switch self {
        case .playPause:
            return .space
        case .nextFrame:
            return .rightArrow
        case .previousFrame:
            return .leftArrow
        case .increaseSpeed:
            return .upArrow
        case .decreaseSpeed:
            return .downArrow
        case .toggleLoop:
            return "l"
        case .openFile:
            return "o"
        }
    }
    
    var modifiers: EventModifiers {
        switch self {
        case .openFile:
            return .command
        default:
            return []
        }
    }
    
    var description: String {
        switch self {
        case .playPause:
            return "Oynat/Durdur"
        case .nextFrame:
            return "Sonraki Kare"
        case .previousFrame:
            return "Önceki Kare"
        case .increaseSpeed:
            return "Hızı Artır"
        case .decreaseSpeed:
            return "Hızı Azalt"
        case .toggleLoop:
            return "Döngüyü Aç/Kapat"
        case .openFile:
            return "Dosya Aç"
        }
    }
    
    var shortcutDescription: String {
        var desc = ""
        if modifiers.contains(.command) {
            desc += "⌘"
        }
        switch self {
        case .playPause:
            desc += "Space"
        case .nextFrame:
            desc += "→"
        case .previousFrame:
            desc += "←"
        case .increaseSpeed:
            desc += "↑"
        case .decreaseSpeed:
            desc += "↓"
        case .toggleLoop:
            desc += "L"
        case .openFile:
            desc += "O"
        }
        return desc
    }
} 