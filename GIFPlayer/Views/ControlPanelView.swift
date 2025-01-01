import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: GIFPlayerViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            // Oynatma kontrolleri
            HStack(spacing: 15) {
                Button(action: viewModel.previousFrame) {
                    Image(systemName: "backward.frame.fill")
                        .font(.title2)
                }
                
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 35))
                }
                
                Button(action: viewModel.nextFrame) {
                    Image(systemName: "forward.frame.fill")
                        .font(.title2)
                }
            }
            .buttonStyle(.plain)
            
            // Kare bilgisi
            Text("\(viewModel.currentFrame + 1)/\(viewModel.totalFrames)")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(width: 80)
        }
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
} 