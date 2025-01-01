import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = GIFPlayerViewModel()
    @State private var showFileImporter = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            if let url = viewModel.gifURL {
                GIFPlayerView(url: url, viewModel: viewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("GIF'i buraya sürükleyin veya tıklayın")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    showFileImporter = true
                }
            }
            
            VStack {
                Spacer()
                if viewModel.gifURL != nil {
                    ControlPanelView(viewModel: viewModel)
                        .padding()
                }
            }
        }
        .onDrop(of: [UTType.gif], isTargeted: nil) { providers in
            guard let provider = providers.first else { return false }
            
            provider.loadItem(forTypeIdentifier: UTType.gif.identifier, options: nil) { item, error in
                if let error = error {
                    showError(message: "GIF yüklenirken hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                guard let urlData = item as? Data,
                      let url = URL(dataRepresentation: urlData, relativeTo: nil) else {
                    showError(message: "GIF dosyası açılamadı.")
                    return
                }
                
                // URL'nin geçerliliğini kontrol et
                guard FileManager.default.fileExists(atPath: url.path) else {
                    showError(message: "GIF dosyası bulunamadı: \(url.path)")
                    return
                }
                
                // GIF dosyasının gerçekten GIF olduğunu kontrol et
                guard let fileType = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
                      UTType(fileType)?.conforms(to: .gif) == true else {
                    showError(message: "Seçilen dosya geçerli bir GIF dosyası değil.")
                    return
                }
                
                DispatchQueue.main.async {
                    print("GIF yükleniyor: \(url.absoluteString)")
                    viewModel.loadGIF(from: url)
                }
            }
            return true
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [UTType.gif],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    // URL'nin geçerliliğini kontrol et
                    guard FileManager.default.fileExists(atPath: url.path) else {
                        showError(message: "GIF dosyası bulunamadı: \(url.path)")
                        return
                    }
                    
                    // GIF dosyasının gerçekten GIF olduğunu kontrol et
                    guard let fileType = try? url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier,
                          UTType(fileType)?.conforms(to: .gif) == true else {
                        showError(message: "Seçilen dosya geçerli bir GIF dosyası değil.")
                        return
                    }
                    
                    print("GIF yükleniyor: \(url.absoluteString)")
                    viewModel.loadGIF(from: url)
                }
            case .failure(let error):
                showError(message: "GIF seçilirken hata oluştu: \(error.localizedDescription)")
            }
        }
        .alert("Hata", isPresented: $showError) {
            Button("Tamam", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
    
    private func showError(message: String) {
        DispatchQueue.main.async {
            errorMessage = message
            showError = true
            print("Hata: \(message)")
        }
    }
} 