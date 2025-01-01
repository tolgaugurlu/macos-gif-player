import SwiftUI

struct AppIcon: View {
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Logo
            VStack(spacing: 4) {
                // "TU" monogramı
                Text("TU")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                // GIF yazısı
                Text("GIF")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
        }
    }
}

// İkon oluşturucu
struct IconGenerator {
    static func generateAppIcon() -> NSImage {
        let size = CGSize(width: 512, height: 512)
        let renderer = ImageRenderer(content: AppIcon()
            .frame(width: size.width, height: size.height)
        )
        
        renderer.scale = 1.0
        
        if let nsImage = renderer.nsImage {
            return nsImage
        }
        
        return NSImage(size: size)
    }
} 