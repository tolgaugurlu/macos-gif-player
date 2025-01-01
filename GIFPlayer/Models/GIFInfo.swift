import Foundation

struct GIFInfo {
    let fileSize: Int64
    let dimensions: CGSize
    let frameCount: Int
    let duration: Double
    let creationDate: Date?
    let modificationDate: Date?
    let loopCount: Int
    let averageFrameDelay: Double
    
    var fileSizeFormatted: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
    
    var dimensionsFormatted: String {
        return String(format: "%.0f x %.0f", dimensions.width, dimensions.height)
    }
    
    var durationFormatted: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "Bilinmiyor"
    }
    
    var creationDateFormatted: String {
        guard let date = creationDate else { return "Bilinmiyor" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    var modificationDateFormatted: String {
        guard let date = modificationDate else { return "Bilinmiyor" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: date)
    }
    
    var frameRateFormatted: String {
        let frameRate = 1.0 / averageFrameDelay
        return String(format: "%.1f FPS", frameRate)
    }
} 