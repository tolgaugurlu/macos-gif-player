import SwiftUI
import AppKit
import ImageIO
import CoreGraphics
import UniformTypeIdentifiers

struct GIFPlayerView: NSViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: GIFPlayerViewModel
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
        view.autoresizingMask = [.width, .height]
        
        // Ana layer'ı oluştur
        let containerLayer = CALayer()
        containerLayer.frame = view.bounds
        containerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        view.layer = containerLayer
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // Dosya erişim izinlerini kontrol et
        let securityScope = url.startAccessingSecurityScopedResource()
        defer {
            if securityScope {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        guard let _ = try? url.checkResourceIsReachable() else {
            print("Hata: GIF dosyasına erişilemiyor: \(url.path)")
            return
        }
        
        // Eğer zaten bir animasyon varsa ve URL aynıysa, tekrar yükleme
        if let currentURL = context.coordinator.currentURL, currentURL == url {
            return
        }
        
        // Önceki animasyonu temizle
        context.coordinator.clearAnimation(from: nsView)
        
        // Yeni animasyonu yükle
        context.coordinator.loadAnimation(from: url, into: nsView, viewModel: viewModel)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator {
        var gifPlayerView: GIFPlayerView
        var currentURL: URL?
        var displayLink: CVDisplayLink?
        var imageSource: CGImageSource?
        var frameCount: Int = 0
        var currentFrame: Int = 0
        var frameDurations: [TimeInterval] = []
        var lastFrameTime: TimeInterval = 0
        var imageLayer: CALayer?
        
        init(_ gifPlayerView: GIFPlayerView) {
            self.gifPlayerView = gifPlayerView
        }
        
        func clearAnimation(from view: NSView) {
            imageLayer?.removeFromSuperlayer()
            imageLayer = nil
            imageSource = nil
            currentURL = nil
            frameDurations.removeAll()
            currentFrame = 0
            
            if let displayLink = displayLink {
                CVDisplayLinkStop(displayLink)
                self.displayLink = nil
            }
        }
        
        func loadAnimation(from url: URL, into view: NSView, viewModel: GIFPlayerViewModel) {
            let options = [kCGImageSourceShouldCache: true] as CFDictionary
            guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, options) else {
                print("Hata: GIF kaynağı oluşturulamadı")
                return
            }
            
            self.imageSource = imageSource
            self.currentURL = url
            self.frameCount = CGImageSourceGetCount(imageSource)
            
            // Frame sürelerini hesapla
            frameDurations = (0..<frameCount).map { index in
                let frameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as? [String: Any]
                let gifProperties = frameProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any]
                let defaultDuration = 0.1
                
                if let delay = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double,
                   delay > 0 {
                    return delay
                } else if let delay = gifProperties?[kCGImagePropertyGIFDelayTime as String] as? Double,
                          delay > 0 {
                    return delay
                }
                return defaultDuration
            }
            
            // Layer'ı hazırla
            let layer = CALayer()
            layer.frame = view.bounds
            layer.contentsGravity = .resizeAspect
            layer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            view.layer?.addSublayer(layer)
            self.imageLayer = layer
            
            // İlk kareyi göster
            if let firstImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) {
                DispatchQueue.main.async {
                    layer.contents = firstImage
                    self.updateLayerFrame(view: view)
                }
            }
            
            // Display link oluştur
            var displayLink: CVDisplayLink?
            CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
            self.displayLink = displayLink
            
            let callback: CVDisplayLinkOutputCallback = { _, _, _, _, _, userData in
                let coordinator = Unmanaged<Coordinator>.fromOpaque(userData!).takeUnretainedValue()
                coordinator.updateAnimation()
                return kCVReturnSuccess
            }
            
            let userInfo = Unmanaged.passUnretained(self).toOpaque()
            CVDisplayLinkSetOutputCallback(displayLink!, callback, userInfo)
            
            // Animasyonu başlat
            CVDisplayLinkStart(displayLink!)
            
            // ViewModel'i güncelle
            DispatchQueue.main.async {
                viewModel.totalFrames = self.frameCount
            }
            
            // Boyut değişikliği için gözlemci ekle
            NotificationCenter.default.addObserver(
                forName: NSView.frameDidChangeNotification,
                object: view,
                queue: .main) { [weak self] _ in
                    self?.updateLayerFrame(view: view)
                }
        }
        
        func updateLayerFrame(view: NSView) {
            guard let layer = imageLayer,
                  let image = layer.contents else { return }
            
            // CGImage'a dönüştür
            let cgImage = (image as! CGImage)
            let imageSize = CGSize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
            let viewSize = view.bounds.size
            
            // En-boy oranını koru
            let scale = min(viewSize.width / imageSize.width, viewSize.height / imageSize.height)
            let newSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            let newOrigin = CGPoint(
                x: (viewSize.width - newSize.width) / 2,
                y: (viewSize.height - newSize.height) / 2
            )
            
            layer.frame = CGRect(origin: newOrigin, size: newSize)
        }
        
        func updateAnimation() {
            guard let imageSource = imageSource,
                  frameCount > 0,
                  let layer = imageLayer,
                  gifPlayerView.viewModel.isPlaying else {
                return
            }
            
            let currentTime = CACurrentMediaTime()
            if currentTime - lastFrameTime >= frameDurations[currentFrame] {
                if let cgImage = CGImageSourceCreateImageAtIndex(imageSource, currentFrame, nil) {
                    DispatchQueue.main.async {
                        layer.contents = cgImage
                        self.gifPlayerView.viewModel.currentFrame = self.currentFrame
                    }
                }
                
                currentFrame = (currentFrame + 1) % frameCount
                lastFrameTime = currentTime
            }
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    }
}

extension GIFPlayerView {
    static func dismantleNSView(_ nsView: NSView, coordinator: Coordinator) {
        coordinator.clearAnimation(from: nsView)
    }
} 