import SwiftUI
import ImageIO
import CoreGraphics
import UniformTypeIdentifiers

struct GIFInfoView: View {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    @State private var gifProperties: [String: Any]?
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.borderless)
                .padding()
            }
            
            if let error = errorMessage {
                Text("Hata: \(error)")
                    .foregroundColor(.red)
            } else if let properties = gifProperties {
                VStack(alignment: .leading, spacing: 10) {
                    Text("GIF Bilgileri")
                        .font(.title)
                        .padding(.bottom)
                    
                    InfoRow(label: "Dosya Adı:", value: url.lastPathComponent)
                    InfoRow(label: "Konum:", value: url.path)
                    
                    if let width = properties[kCGImagePropertyPixelWidth as String] as? Int,
                       let height = properties[kCGImagePropertyPixelHeight as String] as? Int {
                        InfoRow(label: "Boyut:", value: "\(width)x\(height) piksel")
                    }
                    
                    if let gifDict = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                        if let frameCount = gifDict["ImageCount"] as? Int {
                            InfoRow(label: "Kare Sayısı:", value: "\(frameCount)")
                        }
                        if let loopCount = gifDict["LoopCount"] as? Int {
                            InfoRow(label: "Döngü Sayısı:", value: loopCount == 0 ? "Sonsuz" : "\(loopCount)")
                        }
                    }
                    
                    Divider()
                    
                    Text("Geliştirici Bilgileri")
                        .font(.title2)
                        .padding(.vertical)
                    
                    InfoRow(label: "Geliştirici:", value: "Tolga Uğurlu")
                    InfoRow(label: "Versiyon:", value: "1.0.0")
                }
                .padding()
            } else {
                ProgressView("Bilgiler yükleniyor...")
            }
        }
        .frame(width: 400, height: 500)
        .onAppear {
            loadGIFProperties()
        }
    }
    
    private func loadGIFProperties() {
        let securityScoped = url.startAccessingSecurityScopedResource()
        defer {
            if securityScoped {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            errorMessage = "GIF dosyası okunamadı"
            return
        }
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] {
            self.gifProperties = properties
        } else {
            errorMessage = "GIF özellikleri okunamadı"
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    GIFInfoView(url: URL(fileURLWithPath: ""))
} 