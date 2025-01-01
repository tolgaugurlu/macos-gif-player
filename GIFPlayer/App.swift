import SwiftUI

@main
struct GIFPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(macOS 14.0, *) {
                ContentView()
                    .frame(minWidth: 600, minHeight: 400)
            } else {
                Text("Bu uygulama macOS 14.0 veya üzeri gerektirir.")
                    .frame(width: 300, height: 200)
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 800, height: 600)
    }
} 