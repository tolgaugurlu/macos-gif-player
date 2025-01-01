import SwiftUI
import UniformTypeIdentifiers

class GIFPlayerViewModel: ObservableObject {
    @Published var selectedGIFURL: URL?
    @Published var currentFrame: Int = 0
    @Published var totalFrames: Int = 0
    
    func selectGIF() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "gif")!]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                selectedGIFURL = url
                loadGIFMetadata(from: url)
            }
        }
    }
    
    private func loadGIFMetadata(from url: URL) {
        // GIF metadata yükleme işlemi burada gerçekleştirilecek
        // Toplam kare sayısı ve diğer bilgiler alınacak
    }
    
    func nextFrame() {
        guard totalFrames > 0 else { return }
        currentFrame = (currentFrame + 1) % totalFrames
    }
    
    func previousFrame() {
        guard totalFrames > 0 else { return }
        currentFrame = (currentFrame - 1 + totalFrames) % totalFrames
    }
    
    func updatePlaybackSpeed(_ speed: Double) {
        // Oynatma hızı güncelleme işlemi burada gerçekleştirilecek
    }
    
    func toggleLoop() {
        // Döngü modunu açıp kapatma işlemi burada gerçekleştirilecek
    }
} 