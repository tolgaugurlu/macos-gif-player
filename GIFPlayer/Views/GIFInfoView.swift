import SwiftUI

struct GIFInfoView: View {
    let info: GIFInfo
    @Environment(\.dismiss) private var dismiss
    
    private func formatFileSize(_ size: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: size)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("GIF Bilgileri")
                    .font(.headline)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 5)
            
            Group {
                HStack {
                    Text("Boyut:")
                    Text(formatFileSize(info.fileSize))
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Çözünürlük:")
                    Text("\(Int(info.dimensions.width))×\(Int(info.dimensions.height))")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Kare Sayısı:")
                    Text("\(info.frameCount)")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Süre:")
                    Text(String(format: "%.2f saniye", info.duration))
                        .foregroundColor(.secondary)
                }
            }
            .font(.subheadline)
            
            Divider()
                .padding(.vertical, 5)
            
            HStack {
                Text("Geliştirici:")
                Link("Tolga Uğurlu", destination: URL(string: "https://github.com/tolgaugurlu")!)
                    .foregroundColor(.blue)
            }
            .font(.caption)
        }
        .padding()
        .frame(width: 300)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

#Preview {
    if let info = GIFInfo(url: Bundle.main.url(forResource: "sample", withExtension: "gif") ?? URL(fileURLWithPath: "")) {
        GIFInfoView(info: info)
    } else {
        Text("Önizleme için GIF yüklenemedi")
    }
} 