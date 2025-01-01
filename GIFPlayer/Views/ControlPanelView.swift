import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var viewModel: GIFPlayerViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: viewModel.previousFrame) {
                Image(systemName: "backward.frame.fill")
            }
            .keyboardShortcut(.leftArrow, modifiers: [])
            
            Button(action: viewModel.togglePlayPause) {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
            }
            .keyboardShortcut(.space, modifiers: [])
            
            Button(action: viewModel.nextFrame) {
                Image(systemName: "forward.frame.fill")
            }
            .keyboardShortcut(.rightArrow, modifiers: [])
            
            Text("\(viewModel.currentFrame + 1)/\(viewModel.totalFrames)")
                .monospacedDigit()
                .frame(width: 80)
            
            Picker("Efekt", selection: $viewModel.selectedEffect) {
                Text("Normal").tag(Optional<String>.none)
                Text("Siyah Beyaz").tag(Optional("blackAndWhite"))
                Text("Sepya").tag(Optional("sepia"))
                Text("Negatif").tag(Optional("negative"))
            }
            .frame(width: 120)
            
            Button(action: { viewModel.toggleInfo() }) {
                Image(systemName: "info.circle")
                    .symbolVariant(viewModel.showInfo ? .fill : .none)
            }
            .keyboardShortcut("i", modifiers: [])
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.windowBackgroundColor).opacity(0.95))
                .shadow(radius: 5)
        }
    }
} 