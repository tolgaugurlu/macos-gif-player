import SwiftUI

struct LoadingView: View {
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Yarı saydam arka plan
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            // Yükleme göstergesi
            VStack(spacing: 16) {
                // Dönen logo
                ZStack {
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round,
                                dash: [1, 4]
                            )
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(rotation))
                    
                    Text("TU")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                
                Text("Yükleniyor...")
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                rotation = 360
            }
        }
    }
}

#Preview {
    LoadingView()
} 