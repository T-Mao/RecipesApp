import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecipesListViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                content
            }
            .navigationTitle("Recipes")
            .searchable(text: $viewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .automatic),
                        prompt: "Search recipes")
            .toolbar {
                // picker
                ToolbarItem(placement: .navigationBarTrailing) {
                    Picker("Cuisine", selection: $viewModel.selectedFilter) {
                        Text("All").tag(CuisineFilter.all)
                        ForEach(viewModel.cuisines, id: \.self) { name in
                            Text(name).tag(CuisineFilter.specific(name))
                        }
                    }
                    .pickerStyle(.menu)
                    .disabled(viewModel.cuisines.isEmpty)
                }
            }
        }
        .onAppear { viewModel.fetchRecipes() }
    }

    // MARK: - content
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failure(let error):
            VStack(spacing: 8) {
                Text("Failed to load recipes")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                Button("Retry") { viewModel.fetchRecipes() }
                    .buttonStyle(.borderedProminent)
            }
            .padding()

        case .empty:
            emptyStateView

        case .success:
            List(viewModel.visibleRecipes) { recipe in
                NavigationLink {
                    RecipeDetailView(recipe: recipe)
                } label: {
                    RecipeRow(recipe: recipe)
                }
            }
            .listStyle(.plain)
            .refreshable { viewModel.fetchRecipes() }
        }
    }

    // MARK: - empty
    @ViewBuilder
    private var emptyStateView: some View {
        if #available(iOS 17, *) {
            ContentUnavailableView(
                "No Recipes",
                systemImage: "fork.knife",
                description: Text("Swipe down to refresh.")
            )
        } else {
            VStack(spacing: 12) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("No Recipes")
                    .font(.headline)
                Text("Swipe down to refresh.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - row
private struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(
                url: recipe.photoURLSmall,
                placeholder: {
                    ProgressView()
                        .frame(width: 60, height: 60)
                },
                content: { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            )

            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
