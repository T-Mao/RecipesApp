import XCTest
@testable import RecipesApp

final class RecipeAPITests: XCTestCase {

    func testFetchRecipes_ReturnsDecodedArray() async throws {
        let sampleJSON = """
        {
          "recipes": [
            {
              "cuisine":"Test",
              "name":"Foo",
              "uuid":"3B40B70A-1874-4A2D-8975-64B2C1F6A4B0"
            }
          ]
        }
        """.data(using: .utf8)!

        let url = URL(string: "https://example.com")!
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)

        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, sampleJSON)
        }

        let api = DefaultRecipeAPI(session: session, endpoint: url)

        let recipes = try await api.fetchRecipes()

        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes.first?.name, "Foo")
        XCTAssertEqual(recipes.first?.cuisine, "Test")
    }
}

// MARK: - URLProtocol stub
final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = Self.requestHandler else { return }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() { }
}
