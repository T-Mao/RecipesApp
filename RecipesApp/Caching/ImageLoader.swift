import SwiftUI

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var task: Task<Void, Never>?

    func load(from url: URL?) {
        guard let url else { return }

        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }

        task?.cancel()
        task = Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let uiImage = UIImage(data: data) else { return }
                ImageCache.shared.save(uiImage, for: url)
                image = uiImage
            } catch {
                // image remains nil
            }
        }
    }

    func cancel() { task?.cancel() }
}

