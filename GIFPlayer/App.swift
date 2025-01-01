import SwiftUI

@main
struct GIFPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                    if let window = NSApplication.shared.windows.first {
                        window.styleMask.remove(.resizable)
                        window.setContentSize(NSSize(width: 800, height: 600))
                        window.center()
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
} 