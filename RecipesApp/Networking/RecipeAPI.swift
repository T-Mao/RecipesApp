import Foundation

protocol RecipeAPI {
    func fetchRecipes() async throws -> [Recipe]
}

enum RecipeAPIError: Error, LocalizedError {
    case invalidStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidStatusCode(let code):
            return "Unexpected HTTP status code: \(code)"
        }
    }
}

final class DefaultRecipeAPI: RecipeAPI {

    // MARK: - Properties
    private let session: URLSession
    private let endpoint: URL

    // MARK: - Init
    init(
        session: URLSession = .shared,
        endpoint: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    ) {
        self.session = session
        self.endpoint = endpoint
    }

    // MARK: - Public
    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await session.data(from: endpoint)

        guard
            let http = response as? HTTPURLResponse,
            (200..<300).contains(http.statusCode)
        else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw RecipeAPIError.invalidStatusCode(status)
        }

        let decoded = try JSONDecoder().decode(RecipeResponse.self, from: data)
        return decoded.recipes
    }
}
