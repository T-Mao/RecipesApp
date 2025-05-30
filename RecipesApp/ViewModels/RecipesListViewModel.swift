import Foundation
import SwiftUI
import Combine

@MainActor
final class RecipesListViewModel: ObservableObject {

    // MARK: - Published
    @Published private(set) var state: LoadingState<[Recipe]> = .idle
    @Published var selectedFilter: CuisineFilter = .all
    @Published private(set) var cuisines: [String] = []
    
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
                cuisines = Array(Set(recipes.map(\.cuisine))).sorted()
                
            } catch {
                state = .failure(error)
            }
        }
        
    }
    
    var filteredRecipes: [Recipe] {
        guard case .success(let all) = state else { return [] }
        switch selectedFilter {
        case .all:                return all
        case .specific(let name): return all.filter { $0.cuisine == name }
        }
    }

    func cancel() {
        task?.cancel()
    }
}
