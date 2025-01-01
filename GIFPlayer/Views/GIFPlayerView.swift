import SwiftUI
import WebKit

struct GIFPlayerView: NSViewRepresentable {
    let url: URL
    let effect: ImageEffect
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <body style="margin: 0; background-color: transparent;">
            <img src="\(url.path)" style="width: 100%; height: 100%; object-fit: contain; \(effect.cssFilter)">
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
        }
    }
} 