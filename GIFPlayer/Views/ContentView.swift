import SwiftUI
import WebKit
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = GIFPlayerViewModel()
    @StateObject private var themeSettings = ThemeSettings()
    @State private var isPlaying = false
    @State private var playbackSpeed: Double = 1.0
    @State private var showEffectsMenu = false
    @State private var selectedEffect: ImageEffect = .none
    @State private var isDragging = false
    @State private var showShortcutsHelp = false
    @State private var showGIFInfo = false
    
    var body: some View {
        VStack(spacing: 0) {
            if let url = viewModel.selectedGIFURL {
                ZStack(alignment: .topTrailing) {
                    GIFPlayerView(
                        url: url,
                        effect: selectedEffect,
                        isPlaying: $isPlaying,
                        playbackSpeed: $playbackSpeed
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        // Kare sayısı göstergesi
                        Text("Kare: \(viewModel.currentFrame + 1)/\(viewModel.totalFrames)")
                            .font(.system(.caption, design: .monospaced))
                            .padding(6)
                            .background(.ultraThinMaterial)
                            .cornerRadius(6)
                        
                        HStack(spacing: 8) {
                            // GIF bilgi butonu
                            Button(action: { showGIFInfo.toggle() }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }
                            .buttonStyle(.plain)
                            .help("GIF Bilgileri")
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 32, height: 32)
                            )
                            
                            // Tema seçici
                            ThemePickerView()
                        }
                    }
                    .padding(8)
                }
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
            .overlay(alignment: .trailing) {
                Button(action: { showShortcutsHelp.toggle() }) {
                    Image(systemName: "keyboard")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .help("Klavye Kısayolları")
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .preferredColorScheme(themeSettings.selectedTheme.colorScheme)
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
        .sheet(isPresented: $showShortcutsHelp) {
            ShortcutsHelpView()
                .environmentObject(themeSettings)
        }
        .sheet(isPresented: $showGIFInfo) {
            if let info = viewModel.gifInfo {
                GIFInfoView(gifInfo: info)
                    .environmentObject(themeSettings)
            }
        }
        // Klavye kısayolları
        .onKeyPress(.space) { _ in
            togglePlayback()
            return .handled
        }
        .onKeyPress(.rightArrow) { _ in
            viewModel.nextFrame()
            return .handled
        }
        .onKeyPress(.leftArrow) { _ in
            viewModel.previousFrame()
            return .handled
        }
        .onKeyPress(.upArrow) { _ in
            playbackSpeed = min(playbackSpeed + 0.1, 2.0)
            return .handled
        }
        .onKeyPress(.downArrow) { _ in
            playbackSpeed = max(playbackSpeed - 0.1, 0.1)
            return .handled
        }
        .onKeyPress("l") { _ in
            viewModel.toggleLoop()
            return .handled
        }
        .onKeyPress("i") { _ in
            if viewModel.gifInfo != nil {
                showGIFInfo.toggle()
            }
            return .handled
        }
        .environmentObject(themeSettings)
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
        if isPlaying {
            viewModel.updatePlaybackSpeed(playbackSpeed)
        }
    }
}

struct ShortcutsHelpView: View {
    let shortcuts: [KeyboardShortcut] = [
        .playPause, .nextFrame, .previousFrame,
        .increaseSpeed, .decreaseSpeed, .toggleLoop,
        .openFile
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Klavye Kısayolları")
                .font(.title)
                .padding(.bottom)
            
            ForEach(shortcuts, id: \.rawValue) { shortcut in
                HStack {
                    Text(shortcut.description)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(shortcut.shortcutDescription)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.2))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 400)
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