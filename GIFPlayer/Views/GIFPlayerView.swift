import SwiftUI
import WebKit

struct GIFPlayerView: NSViewRepresentable {
    let url: URL
    let effect: ImageEffect
    @Binding var isPlaying: Bool
    @Binding var playbackSpeed: Double
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        let playbackSpeedJS = isPlaying ? String(format: "%.2f", 1.0 / playbackSpeed) : "0"
        let html = """
        <html>
        <head>
            <style>
                body { margin: 0; background-color: transparent; }
                img { width: 100%; height: 100%; object-fit: contain; \(effect.cssFilter) }
            </style>
            <script>
                function updatePlaybackSpeed(speed) {
                    const img = document.querySelector('img');
                    if (speed === 0) {
                        img.style.animationPlayState = 'paused';
                    } else {
                        img.style.animationDuration = speed + 's';
                        img.style.animationPlayState = 'running';
                    }
                }
            </script>
        </head>
        <body>
            <img src="\(url.path)" style="animation: playGif \(playbackSpeedJS)s steps(1) infinite;">
            <script>
                updatePlaybackSpeed('\(playbackSpeedJS)');
            </script>
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}

enum ImageEffect: String, CaseIterable {
    case none = "Normal"
    case grayscale = "Siyah-Beyaz"
    case sepia = "Sepya"
    case blur = "Bulanık"
    case brightness = "Parlak"
    case invert = "Negatif"
    case saturate = "Canlı"
    
    var cssFilter: String {
        switch self {
        case .none:
            return ""
        case .grayscale:
            return "filter: grayscale(100%);"
        case .sepia:
            return "filter: sepia(100%);"
        case .blur:
            return "filter: blur(2px);"
        case .brightness:
            return "filter: brightness(150%);"
        case .invert:
            return "filter: invert(100%);"
        case .saturate:
            return "filter: saturate(200%);"
        }
    }
} 