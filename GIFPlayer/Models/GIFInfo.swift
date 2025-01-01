import Foundation
import ImageIO
import CoreGraphics

struct GIFInfo {
    let fileSize: Int64
    let dimensions: CGSize
    let frameCount: Int
    let duration: Double
    
    init?(url: URL) {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        
        let properties = CGImageSourceCopyProperties(source, nil) as? [String: Any]
        let gifProperties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any]
        
        // Dosya boyutu
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: url.path)
        fileSize = fileAttributes?[.size] as? Int64 ?? 0
        
        // Boyutlar
        if let width = gifProperties?[kCGImagePropertyPixelWidth as String] as? Double,
           let height = gifProperties?[kCGImagePropertyPixelHeight as String] as? Double {
            dimensions = CGSize(width: width, height: height)
        } else {
            dimensions = .zero
        }
        
        // Kare sayısı
        frameCount = CGImageSourceGetCount(source)
        
        // Süre
        if let gifDict = gifProperties?[kCGImagePropertyGIFDictionary as String] as? [String: Any],
           let duration = gifDict[kCGImagePropertyGIFDelayTime as String] as? Double {
            self.duration = duration * Double(frameCount)
        } else {
            duration = 0
        }
    }
    
    func formattedFileSize() -> String {
        let byteCountFormatter = ByteCountFormatter()
        byteCountFormatter.allowedUnits = [.useBytes, .useKB, .useMB]
        byteCountFormatter.countStyle = .file
        return byteCountFormatter.string(fromByteCount: fileSize)
    }
} 