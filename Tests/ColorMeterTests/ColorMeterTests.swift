import XCTest
@testable import ColorMeter

final class ColorMeterTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ColorMeter().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
