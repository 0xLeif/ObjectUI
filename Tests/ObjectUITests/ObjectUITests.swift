    import XCTest
    @testable import ObjectUI

    final class ObjectUITests: XCTestCase {
        func testExample() {
            enum Value: String {
                case text
            }
            let object = Object()
            object.set(variable: Value.text, value: "Hello, World!")
            XCTAssertEqual(object.text.value(), "Hello, World!")
        }
    }
