import Foundation

enum LoadingState<Value> {
    case idle
    case loading
    case success(Value)
    case empty
    case failure(Error)
}

extension LoadingState: Equatable where Value: Equatable {
    static func == (lhs: LoadingState<Value>, rhs: LoadingState<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.empty, .empty):
            return true
        case let (.success(l), .success(r)):
            return l == r
        default:
            return false
        }
    }
}
