import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var sheetURL: URL?

    var body: some View {
        ScrollView {
            // image
            CachedAsyncImage(
                url: recipe.photoURLLarge ?? recipe.photoURLSmall,
                placeholder: { ZStack { Color(.secondarySystemBackground); ProgressView() }.frame(height: 240) },
                content: { image in
                    image.resizable()
                         .scaledToFill()
                         .frame(maxWidth: .infinity, maxHeight: 300)
                         .clipped()
                }
            )

            VStack(alignment: .leading, spacing: 16) {
                Text(recipe.name).font(.largeTitle).bold()
                Text(recipe.cuisine).font(.title3).foregroundStyle(.secondary)

                // video button
                if let yt = recipe.youtubeURL {
                    Button {
                        sheetURL = yt
                    } label: {
                        Label("Watch Video", systemImage: "play.rectangle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }

                // web button
                if let source = recipe.sourceURL {
                    Button {
                        sheetURL = source
                    } label: {
                        Label("View Original Recipe", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
        // Safari sheet
        .sheet(item: $sheetURL) { url in
            SafariSheet(url: url)
        }
    }
}

extension URL: Identifiable {
    public var id: String { absoluteString }
}
