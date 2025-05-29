import Foundation
import SwiftUI
import Combine

@MainActor
final class RecipesListViewModel: ObservableObject {

    // MARK: - Published
    @Published private(set) var state: LoadingState<[Recipe]> = .idle

    // MARK: - Dependencies
    private let api: RecipeAPI
    private var task: Task<Void, Never>?

    // MARK: - Init
    init(api: RecipeAPI = DefaultRecipeAPI()) {
        self.api = api
    }

    // MARK: - Public
    func fetchRecipes() {
        task?.cancel()
        state = .loading

        task = Task {
            do {
                let recipes = try await api.fetchRecipes()
                state = recipes.isEmpty ? .empty : .success(recipes)
            } catch {
                state = .failure(error)
            }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
