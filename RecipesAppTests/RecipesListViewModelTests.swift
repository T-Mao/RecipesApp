import XCTest
@testable import RecipesApp

// MARK: - Mock API
struct MockRecipeAPI: RecipeAPI {
    enum Stub {
        case success([Recipe])
        case failure(Error)
    }
    let stub: Stub

    func fetchRecipes() async throws -> [Recipe] {
        switch stub {
        case .success(let recipes): return recipes
        case .failure(let error):   throw error
        }
    }
}

// MARK: - Tests
@MainActor
final class RecipesListViewModelTests: XCTestCase {

    func testFetchRecipes_SuccessState() async {
        // Arrange
        let sample = [Recipe(id: UUID(),
                             name: "Foo",
                             cuisine: "Test",
                             photoURLLarge: nil,
                             photoURLSmall: nil,
                             sourceURL: nil,
                             youtubeURL: nil)]
        let vm = RecipesListViewModel(api: MockRecipeAPI(stub: .success(sample)))

        // Act
        vm.fetchRecipes()
        try? await Task.sleep(for: .milliseconds(10))

        // Assert
        if case .success(let recipes) = vm.state {
            XCTAssertEqual(recipes, sample)
        } else {
            XCTFail("Expected success state")
        }
    }

    func testFetchRecipes_EmptyState() async {
        let vm = RecipesListViewModel(api: MockRecipeAPI(stub: .success([])))
        vm.fetchRecipes()
        try? await Task.sleep(for: .milliseconds(10))
        XCTAssertEqual(vm.state, .empty)
    }

    func testFetchRecipes_FailureState() async {
        struct DummyError: Error {}
        let vm = RecipesListViewModel(api: MockRecipeAPI(stub: .failure(DummyError())))
        vm.fetchRecipes()
        try? await Task.sleep(for: .milliseconds(10))

        if case .failure = vm.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected failure state")
        }
    }
}
