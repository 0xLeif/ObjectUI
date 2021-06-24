import XCTest
@testable import ObjectUI

final class ObjectUITests: XCTestCase {
    func testExample() {
        enum Value: String {
            case text
        }
        let object = Object()
        object.set(variable: Value.text, value: "Hello, World!")
        
        XCTAssertEqual(object.variable(named: Value.text).value(), "Hello, World!")
    }
    
    func testTextVariable() {
        let object = Object()
        object.set(variable: "text", value: "Hello, World!")
        
        XCTAssertEqual(object.text.value(), "Hello, World!")
    }
    
    func testArray() {
        let json = """
            [
                {
                  "userId": 19,
                  "id": 2,
                  "title": "quis ut nam facilis et officia qui",
                  "completed": false
                },
                {
                  "userId": 1,
                  "id": 8,
                  "title": "quo adipisci enim quam ut ab",
                  "completed": true
                }
            ]
            """
            .data(using: .utf8)
        
        let object = Object(json)
        
        XCTAssertEqual(object.array.count, 2)
        
        let post = object.array[0]
        
        XCTAssertEqual(post.userId.value(), 19)
        XCTAssertEqual(post.id.value(), 2)
        XCTAssertEqual(post.title.value(), "quis ut nam facilis et officia qui")
        XCTAssertEqual(post.completed.value(), false)
    }
}
