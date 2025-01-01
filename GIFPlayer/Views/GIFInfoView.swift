import SwiftUI

struct GIFInfoView: View {
    let gifInfo: GIFInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GIF Bilgileri")
                .font(.title2)
                .bold()
            
            InfoGroup(title: "Dosya Bilgileri") {
                InfoRow(label: "Boyut", value: gifInfo.fileSizeFormatted)
                InfoRow(label: "Oluşturulma", value: gifInfo.creationDateFormatted)
                InfoRow(label: "Değiştirilme", value: gifInfo.modificationDateFormatted)
            }
            
            InfoGroup(title: "Görüntü Bilgileri") {
                InfoRow(label: "Boyutlar", value: gifInfo.dimensionsFormatted)
                InfoRow(label: "Kare Sayısı", value: "\(gifInfo.frameCount)")
                InfoRow(label: "Kare Hızı", value: gifInfo.frameRateFormatted)
                InfoRow(label: "Süre", value: gifInfo.durationFormatted)
                InfoRow(label: "Döngü", value: gifInfo.loopCount == 0 ? "Sonsuz" : "\(gifInfo.loopCount)")
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct InfoGroup<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            content
                .padding(.leading, 8)
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
        .font(.system(.body, design: .monospaced))
    }
}

#Preview {
    GIFInfoView(gifInfo: GIFInfo(
        fileSize: 1024 * 1024,
        dimensions: CGSize(width: 800, height: 600),
        frameCount: 24,
        duration: 2.4,
        creationDate: Date(),
        modificationDate: Date(),
        loopCount: 0,
        averageFrameDelay: 0.1
    ))
} 