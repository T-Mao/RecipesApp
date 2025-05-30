import SwiftUI

struct CachedAsyncImage<Placeholder: View, Content: View>: View {
    private let url: URL?
    private let placeholder: Placeholder
    private let content: (Image) -> Content

    @StateObject private var loader = ImageLoader()

    init(
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.url = url
        self.placeholder = placeholder()
        self.content = content
    }

    var body: some View {
        Group {
            if let uiImage = loader.image {
                content(Image(uiImage: uiImage))
            } else {
                placeholder
            }
        }
        .onAppear { loader.load(from: url) }
        .onDisappear { loader.cancel() }
    }
}
