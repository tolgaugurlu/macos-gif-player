import SwiftUI
import WebKit
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = GIFPlayerViewModel()
    @State private var isPlaying = false
    @State private var playbackSpeed: Double = 1.0
    @State private var showEffectsMenu = false
    @State private var selectedEffect: ImageEffect = .none
    @State private var isDragging = false
    
    var body: some View {
        VStack(spacing: 0) {
            if let url = viewModel.selectedGIFURL {
                GIFPlayerView(
                    url: url,
                    effect: selectedEffect,
                    isPlaying: $isPlaying,
                    playbackSpeed: $playbackSpeed
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                EmptyStateView(isDragging: isDragging)
            }
            
            ControlPanelView(
                isPlaying: $isPlaying,
                playbackSpeed: $playbackSpeed,
                showEffectsMenu: $showEffectsMenu,
                selectedEffect: $selectedEffect,
                onOpenTapped: viewModel.selectGIF,
                onPlayPauseTapped: togglePlayback,
                onNextFrame: viewModel.nextFrame,
                onPreviousFrame: viewModel.previousFrame
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: playbackSpeed) { newSpeed in
            viewModel.updatePlaybackSpeed(newSpeed)
        }
        .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers -> Bool in
            guard let provider = providers.first else { return false }
            
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data,
                       let path = String(data: urlData, encoding: .utf8),
                       let url = URL(string: path) {
                        
                        // Sadece .gif uzantılı dosyaları kabul et
                        if url.pathExtension.lowercased() == "gif" {
                            viewModel.loadGIF(from: url)
                        }
                    }
                }
            }
            return true
        }
        .alert(
            "Hata",
            isPresented: .constant(viewModel.loadError != nil),
            actions: {
                Button("Tamam") {
                    viewModel.loadError = nil
                }
            },
            message: {
                if let error = viewModel.loadError {
                    Text(error)
                }
            }
        )
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            viewModel.updatePlaybackSpeed(playbackSpeed)
        }
    }
}

struct EmptyStateView: View {
    var isDragging: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(isDragging ? .blue : .gray)
                .scaleEffect(isDragging ? 1.2 : 1.0)
                .animation(.spring(), value: isDragging)
            
            Text("GIF Dosyası Seçin")
                .font(.title2)
                .foregroundColor(isDragging ? .blue : .gray)
            
            Text("veya sürükleyip bırakın")
                .font(.subheadline)
                .foregroundColor(isDragging ? .blue : .gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isDragging ? Color.blue : Color.clear, style: StrokeStyle(lineWidth: 2, dash: [5]))
                .animation(.easeInOut, value: isDragging)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 