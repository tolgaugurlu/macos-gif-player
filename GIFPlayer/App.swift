import SwiftUI
import AppKit

// AboutView tanımı
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
                .padding(.trailing, 10)
                .padding(.top, 10)
            }
            
            Image(systemName: "play.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("GIFPlayer")
                .font(.system(size: 24, weight: .bold))
            
            Text("Sürüm 1.0.0")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Geliştirici")
                    .font(.headline)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Tolga Uğurlu")
                            .font(.title3)
                            .bold()
                        Text("Yazılım Mühendisi & Uygulama Geliştiricisi")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                
                Text("İletişim")
                    .font(.headline)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Link("GitHub", destination: URL(string: "https://github.com/tolgaugurlu")!)
                        Link("LinkedIn", destination: URL(string: "https://linkedin.com/in/tolgaugurlu")!)
                        Link("Twitter", destination: URL(string: "https://twitter.com/tolgaaugurlu")!)
                    }
                    .font(.system(size: 14))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
            
            Text("Copyright © 2024 Tolga Uğurlu. Tüm hakları saklıdır.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(width: 400, height: 500)
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
    }
}

class AppState: ObservableObject {
    @Published var showAbout = false
}

@main
struct GIFPlayerApp: App {
    @StateObject private var appState = AppState()
    
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
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("GIFPlayer Hakkında") {
                    appState.showAbout.toggle()
                }
                .keyboardShortcut("i", modifiers: [.command])
            }
        }
    }
} 