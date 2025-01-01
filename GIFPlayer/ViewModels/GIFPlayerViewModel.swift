import SwiftUI
import UniformTypeIdentifiers
import ImageIO

class GIFPlayerViewModel: ObservableObject {
    @Published var selectedGIFURL: URL?
    @Published var currentFrame: Int = 0
    @Published var totalFrames: Int = 0
    @Published var isLooping: Bool = true
    @Published var frameDelay: Double = 0.1
    @Published var loadError: String?
    @Published var gifInfo: GIFInfo?
    @Published var isLoading: Bool = false
    
    private var imageSource: CGImageSource?
    private let cache = GIFCache.shared
    private var loadTask: Task<Void, Never>?
    
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
        // Önceki yükleme işlemini iptal et
        loadTask?.cancel()
        
        isLoading = true
        loadTask = Task {
            do {
                // Önbellekte var mı kontrol et
                if let cachedSource = cache.getCachedGIF(for: url) {
                    imageSource = cachedSource
                    selectedGIFURL = url
                    totalFrames = CGImageSourceGetCount(cachedSource)
                    loadGIFInfo(from: url, source: cachedSource)
                    return
                }
                
                let data = try Data(contentsOf: url)
                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                    await MainActor.run {
                        loadError = "GIF dosyası okunamadı"
                        isLoading = false
                    }
                    return
                }
                
                // GIF formatını kontrol et
                guard let type = CGImageSourceGetType(source) as String?,
                      type == kUTTypeGIF as String else {
                    await MainActor.run {
                        loadError = "Geçersiz GIF dosyası"
                        isLoading = false
                    }
                    return
                }
                
                // Önbelleğe al
                cache.cacheGIF(source, for: url)
                
                await MainActor.run {
                    selectedGIFURL = url
                    imageSource = source
                    totalFrames = CGImageSourceGetCount(source)
                    loadGIFInfo(from: url, source: source)
                    currentFrame = 0
                    loadError = nil
                    isLoading = false
                }
                
                // Kareleri arka planda önbelleğe al
                Task.detached(priority: .background) {
                    await self.precacheFrames(source: source, url: url)
                }
                
            } catch {
                await MainActor.run {
                    loadError = "GIF dosyası yüklenirken hata oluştu: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
    
    private func precacheFrames(source: CGImageSource, url: URL) async {
        let frameCount = CGImageSourceGetCount(source)
        for i in 0..<frameCount {
            guard let frame = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            let key = "\(url.absoluteString)_frame_\(i)"
            cache.cacheFrame(frame, for: key)
        }
    }
    
    private func loadGIFInfo(from url: URL, source: CGImageSource) {
        // Dosya boyutu
        let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize ?? 0
        
        // Boyutlar
        var dimensions = CGSize.zero
        if let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any],
           let width = properties[kCGImagePropertyPixelWidth as String] as? Double,
           let height = properties[kCGImagePropertyPixelHeight as String] as? Double {
            dimensions = CGSize(width: width, height: height)
        }
        
        // Toplam süre ve ortalama kare gecikmesi
        var totalDuration: Double = 0
        var totalDelay: Double = 0
        for i in 0..<totalFrames {
            if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil) as? [String: Any],
               let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
               let delay = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                totalDuration += delay
                totalDelay += delay
            }
        }
        let averageDelay = totalDelay / Double(totalFrames)
        
        // Döngü sayısı
        var loopCount = 0
        if let properties = CGImageSourceCopyProperties(source, nil) as? [String: Any],
           let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any],
           let loops = gifProperties[kCGImagePropertyGIFLoopCount as String] as? Int {
            loopCount = loops
        }
        
        // Dosya tarihleri
        let resourceValues = try? url.resourceValues(forKeys: [.creationDateKey, .contentModificationDateKey])
        
        gifInfo = GIFInfo(
            fileSize: Int64(fileSize ?? 0),
            dimensions: dimensions,
            frameCount: totalFrames,
            duration: totalDuration,
            creationDate: resourceValues?.creationDate,
            modificationDate: resourceValues?.contentModificationDate,
            loopCount: loopCount,
            averageFrameDelay: averageDelay
        )
        
        // Kare gecikmesini güncelle
        frameDelay = averageDelay
    }
    
    func getFrame(at index: Int) -> CGImage? {
        guard let url = selectedGIFURL else { return nil }
        
        // Önbellekten kareyi al
        let key = "\(url.absoluteString)_frame_\(index)"
        if let cachedFrame = cache.getCachedFrame(for: key) {
            return cachedFrame
        }
        
        // Önbellekte yoksa, kaynaktan yükle ve önbelleğe al
        guard let source = imageSource,
              index < totalFrames,
              let frame = CGImageSourceCreateImageAtIndex(source, index, nil) else {
            return nil
        }
        
        cache.cacheFrame(frame, for: key)
        return frame
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
    
    deinit {
        loadTask?.cancel()
        if let url = selectedGIFURL {
            cache.clearFrameCache(for: url)
        }
    }
} 