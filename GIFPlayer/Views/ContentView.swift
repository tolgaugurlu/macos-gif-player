import SwiftUI
import WebKit

struct ContentView: View {
    @StateObject private var viewModel = GIFPlayerViewModel()
    @State private var isPlaying = false
    @State private var playbackSpeed: Double = 1.0
    @State private var showEffectsMenu = false
    @State private var selectedEffect: ImageEffect = .none
    
    var body: some View {
        VStack(spacing: 0) {
            if let url = viewModel.selectedGIFURL {
                GIFPlayerView(url: url, effect: selectedEffect)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                EmptyStateView()
            }
            
            ControlPanelView(
                isPlaying: $isPlaying,
                playbackSpeed: $playbackSpeed,
                showEffectsMenu: $showEffectsMenu,
                selectedEffect: $selectedEffect,
                onOpenTapped: viewModel.selectGIF,
                onPlayPauseTapped: togglePlayback,
                onNextFrame: nextFrame,
                onPreviousFrame: previousFrame
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
        // Implement playback logic
    }
    
    private func nextFrame() {
        // Implement next frame logic
    }
    
    private func previousFrame() {
        // Implement previous frame logic
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            Text("GIF Dosyası Seçin")
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 