import XCTest
@testable import lambdatools

class lambdatoolsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(lambdatools().text, "Hello, World!")
    }


    static var allTests : [(String, (lambdatoolsTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
