import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe

    var body: some View {
        ScrollView {
            CachedAsyncImage(
                url: recipe.photoURLLarge ?? recipe.photoURLSmall,
                placeholder: {
                    ZStack { Color(.secondarySystemBackground); ProgressView() }
                        .frame(height: 240)
                },
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                }
            )

            VStack(alignment: .leading, spacing: 12) {
                Text(recipe.name)
                    .font(.largeTitle).bold()

                Text("Cuisine: \(recipe.cuisine)")
                    .font(.title3)
                    .foregroundStyle(.secondary)

                if let source = recipe.sourceURL {
                    Link(destination: source) {
                        Label("View Original Source", systemImage: "safari")
                    }
                }

                if let youtube = recipe.youtubeURL {
                    Link(destination: youtube) {
                        Label("Watch on YouTube", systemImage: "play.rectangle")
                    }
                }
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecipeDetailView(
        recipe: .init(
            id: UUID(),
            name: "Test",
            cuisine: "Foo",
            photoURLLarge: nil,
            photoURLSmall: nil,
            sourceURL: nil,
            youtubeURL: nil
        )
    )
}
