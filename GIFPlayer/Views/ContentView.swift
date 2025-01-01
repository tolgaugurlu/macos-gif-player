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
                GIFPlayerView(
                    url: url,
                    effect: selectedEffect,
                    isPlaying: $isPlaying,
                    playbackSpeed: $playbackSpeed
                )
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
                onNextFrame: viewModel.nextFrame,
                onPreviousFrame: viewModel.previousFrame
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: playbackSpeed) { newSpeed in
            viewModel.updatePlaybackSpeed(newSpeed)
        }
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            viewModel.updatePlaybackSpeed(playbackSpeed)
        }
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
            Text("veya sürükleyip bırakın")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 