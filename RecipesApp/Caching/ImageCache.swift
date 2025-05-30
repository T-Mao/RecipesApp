import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskDirectory: URL

    private init() {
        diskDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("com.fetch.recipes.images", isDirectory: true)

        try? FileManager.default.createDirectory(at: diskDirectory,
                                                 withIntermediateDirectories: true,
                                                 attributes: nil)
    }

    // MARK: - Public API
    func image(for url: URL) -> UIImage? {
        let key = cacheKey(for: url)

        if let image = memoryCache.object(forKey: key as NSString) { return image }

        let fileURL = diskDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL),
           let img = UIImage(data: data) {
            memoryCache.setObject(img, forKey: key as NSString)
            return img
        }
        return nil
    }

    func save(_ image: UIImage, for url: URL) {
        let key = cacheKey(for: url)
        memoryCache.setObject(image, forKey: key as NSString)

        let fileURL = diskDirectory.appendingPathComponent(key)
        guard !FileManager.default.fileExists(atPath: fileURL.path),
              let data = image.jpegData(compressionQuality: 0.9) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    // MARK: - Helpers
    private func cacheKey(for url: URL) -> String {
        Data(url.absoluteString.utf8)
            .base64EncodedString()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "+", with: "-")
    }
}
