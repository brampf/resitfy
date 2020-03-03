import XCTest
@testable import Restify

final class RestifyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Restify().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
