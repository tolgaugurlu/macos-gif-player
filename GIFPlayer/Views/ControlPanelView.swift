import SwiftUI

struct ControlPanelView: View {
    @Binding var isPlaying: Bool
    @Binding var playbackSpeed: Double
    @Binding var showEffectsMenu: Bool
    @Binding var selectedEffect: ImageEffect
    
    let onOpenTapped: () -> Void
    let onPlayPauseTapped: () -> Void
    let onNextFrame: () -> Void
    let onPreviousFrame: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: onOpenTapped) {
                Image(systemName: "folder")
                    .font(.title2)
            }
            .help("GIF Dosyası Aç")
            
            Divider()
            
            HStack(spacing: 12) {
                Button(action: onPreviousFrame) {
                    Image(systemName: "backward.frame")
                        .font(.title2)
                }
                .help("Önceki Kare")
                
                Button(action: onPlayPauseTapped) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
                .help(isPlaying ? "Durdur" : "Oynat")
                
                Button(action: onNextFrame) {
                    Image(systemName: "forward.frame")
                        .font(.title2)
                }
                .help("Sonraki Kare")
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Hız: \(String(format: "%.1fx", playbackSpeed))")
                    .font(.caption)
                Slider(value: $playbackSpeed, in: 0.1...2.0)
                    .frame(width: 100)
            }
            
            Divider()
            
            Menu {
                ForEach(ImageEffect.allCases, id: \.self) { effect in
                    Button(effect.rawValue) {
                        selectedEffect = effect
                    }
                }
            } label: {
                Image(systemName: "wand.and.stars")
                    .font(.title2)
            }
            .help("Efektler")
        }
        .padding()
        .background(VisualEffectView())
    }
}

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .hudWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
} 