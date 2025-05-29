import Foundation

struct Recipe: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let cuisine: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    private enum CodingKeys: String, CodingKey {
        case id            = "uuid"
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL     = "source_url"
        case youtubeURL    = "youtube_url"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
