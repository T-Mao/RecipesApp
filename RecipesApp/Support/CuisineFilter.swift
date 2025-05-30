import Foundation

enum CuisineFilter: Hashable {
    case all
    case specific(String)

    var title: String {
        switch self {
        case .all: return "All"
        case .specific(let name): return name
        }
    }
}
