import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: GIFPlayerViewModel
    @State private var showInfo = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Oynatma kontrolleri
            HStack(spacing: 15) {
                Button(action: viewModel.previousFrame) {
                    Image(systemName: "backward.frame.fill")
                }
                
                Button(action: viewModel.togglePlayPause) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                }
                
                Button(action: viewModel.nextFrame) {
                    Image(systemName: "forward.frame.fill")
                }
            }
            .font(.title2)
            
            // Kare bilgisi
            Text("\(viewModel.currentFrame + 1)/\(viewModel.totalFrames)")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 80)
            
            // Bilgi butonu
            Button(action: { showInfo.toggle() }) {
                Image(systemName: "info.circle")
                    .font(.title2)
            }
            .popover(isPresented: $showInfo) {
                if let url = viewModel.gifURL,
                   let info = GIFInfo(url: url) {
                    GIFInfoView(info: info)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(10)
        .background(.ultraThinMaterial)
        .cornerRadius(10)
    }
} 