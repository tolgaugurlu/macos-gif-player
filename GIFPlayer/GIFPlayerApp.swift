import SwiftUI

@main
struct GIFPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 300)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
} 