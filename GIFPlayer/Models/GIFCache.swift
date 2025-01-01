import Foundation
import ImageIO
import AppKit

final class GIFCache {
    static let shared = GIFCache()
    private var cache = NSCache<NSURL, CGImageSource>()
    private var frameCache = NSCache<NSString, CGImage>()
    private var frameKeys = Set<String>()
    
    private init() {
        // Önbellek boyut limitleri
        cache.countLimit = 5 // En fazla 5 GIF
        frameCache.countLimit = 300 // En fazla 300 kare
        
        // Bellek baskısı olduğunda otomatik temizleme
        NotificationCenter.default.addObserver(
            forName: NSApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.clearCache()
        }
    }
    
    func cacheGIF(_ source: CGImageSource, for url: URL) {
        cache.setObject(source, forKey: url as NSURL)
    }
    
    func getCachedGIF(for url: URL) -> CGImageSource? {
        return cache.object(forKey: url as NSURL)
    }
    
    func cacheFrame(_ image: CGImage, for key: String) {
        frameCache.setObject(image, forKey: key as NSString)
        frameKeys.insert(key)
    }
    
    func getCachedFrame(for key: String) -> CGImage? {
        return frameCache.object(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
        frameCache.removeAllObjects()
        frameKeys.removeAll()
    }
    
    func removeCachedGIF(for url: URL) {
        cache.removeObject(forKey: url as NSURL)
    }
    
    // Belirli bir GIF'in tüm karelerini önbellekten temizle
    func clearFrameCache(for url: URL) {
        let prefix = url.absoluteString
        let keysToRemove = frameKeys.filter { $0.hasPrefix(prefix) }
        for key in keysToRemove {
            frameCache.removeObject(forKey: key as NSString)
            frameKeys.remove(key)
        }
    }
    
    // Önbellek durumunu kontrol et
    var statistics: String {
        """
        GIF Önbellek İstatistikleri:
        - Önbellekteki GIF sayısı: \(cache.name?.count ?? 0)
        - Önbellekteki kare sayısı: \(frameKeys.count)
        """
    }
} 