import SwiftUI
import UniformTypeIdentifiers
import ImageIO

class GIFPlayerViewModel: ObservableObject {
    @Published var selectedGIFURL: URL?
    @Published var currentFrame: Int = 0
    @Published var totalFrames: Int = 0
    @Published var isLooping: Bool = true
    @Published var frameDelay: Double = 0.1 // Varsayılan kare gecikmesi
    @Published var loadError: String?
    
    private var imageSource: CGImageSource?
    
    func selectGIF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "gif")!]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                loadGIF(from: url)
            }
        }
    }
    
    func loadGIF(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                loadError = "GIF dosyası okunamadı"
                return
            }
            
            // GIF formatını kontrol et
            guard let type = CGImageSourceGetType(source) as String?,
                  type == kUTTypeGIF as String else {
                loadError = "Geçersiz GIF dosyası"
                return
            }
            
            selectedGIFURL = url
            imageSource = source
            totalFrames = CGImageSourceGetCount(source)
            
            // İlk karenin gecikmesini al
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delay = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                frameDelay = delay
            }
            
            currentFrame = 0
            loadError = nil
            print("GIF yüklendi: \(totalFrames) kare, \(frameDelay) saniye gecikme")
        } catch {
            loadError = "GIF dosyası yüklenirken hata oluştu: \(error.localizedDescription)"
        }
    }
    
    private func loadGIFMetadata(from url: URL) {
        loadGIF(from: url)
    }
    
    func nextFrame() {
        guard totalFrames > 0 else { return }
        currentFrame = (currentFrame + 1) % totalFrames
        updateCurrentFrame()
    }
    
    func previousFrame() {
        guard totalFrames > 0 else { return }
        currentFrame = (currentFrame - 1 + totalFrames) % totalFrames
        updateCurrentFrame()
    }
    
    private func updateCurrentFrame() {
        objectWillChange.send()
    }
    
    func updatePlaybackSpeed(_ speed: Double) {
        frameDelay = 0.1 / speed
    }
    
    func toggleLoop() {
        isLooping.toggle()
    }
    
    func getFrame(at index: Int) -> CGImage? {
        guard let source = imageSource,
              index < totalFrames,
              let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else {
            return nil
        }
        return cgImage
    }
} 