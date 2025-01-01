import SwiftUI
import Combine
import UniformTypeIdentifiers
import ImageIO

class GIFPlayerViewModel: ObservableObject {
    @Published var gifURL: URL?
    @Published var isPlaying = false
    @Published var currentFrame = 0
    @Published var totalFrames = 0
    @Published var selectedEffect: String?
    @Published var showInfo = false
    
    func loadGIF(from url: URL) {
        // URL'nin geçerliliğini kontrol et
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Hata: GIF dosyası bulunamadı: \(url.path)")
            return
        }
        
        // GIF dosyasının gerçekten GIF olduğunu kontrol et
        guard let fileType = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
              UTType(fileType)?.conforms(to: .gif) == true else {
            print("Hata: Seçilen dosya geçerli bir GIF dosyası değil.")
            return
        }
        
        print("GIF yüklendi: \(url.path)")
        gifURL = url
        isPlaying = true
        currentFrame = 0
    }
    
    func togglePlayPause() {
        isPlaying.toggle()
    }
    
    func nextFrame() {
        guard currentFrame < totalFrames - 1 else { return }
        currentFrame += 1
    }
    
    func previousFrame() {
        guard currentFrame > 0 else { return }
        currentFrame -= 1
    }
    
    func applyEffect(_ effect: String) {
        selectedEffect = effect
    }
    
    func toggleInfo() {
        showInfo.toggle()
    }
} 