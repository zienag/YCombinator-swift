import XCTest
@testable import YCombinator

class YCombinatorTests: XCTestCase {
  func test_factorial() {
    let Y = YCombinatorFactory<UInt, UInt>().Y
    let factorial = Y { (f) in { (n) in
      n == 0 ? 1 : n * f(n - 1)
    }}
    XCTAssertEqual(factorial(0), 1)
    XCTAssertEqual(factorial(1), 1)
    XCTAssertEqual(factorial(2), 2)
    XCTAssertEqual(factorial(3), 6)
    XCTAssertEqual(factorial(4), 24)
    XCTAssertEqual(factorial(5), 120)
    XCTAssertEqual(factorial(10), 3628800)
  }

  func test_fibonachi() {
    let Y = YCombinatorFactory<UInt, UInt>().Y
    let fibonachi = Y { (f) in { (n: UInt) -> UInt in
      n == 0 ? 0 : (n == 1 ? 1 : f(n - 1) + f(n - 2))
      }}
    XCTAssertEqual(fibonachi(0), 0)
    XCTAssertEqual(fibonachi(1), 1)
    XCTAssertEqual(fibonachi(2), 1)
    XCTAssertEqual(fibonachi(3), 2)
    XCTAssertEqual(fibonachi(4), 3)
    XCTAssertEqual(fibonachi(5), 5)
    XCTAssertEqual(fibonachi(10), 55)
  }

  func test_listcount() {
    let Y = YCombinatorFactory<[Any], UInt>().Y
    let listcount = Y { (f) in { (l: [Any]) -> UInt in
      l.isEmpty ? 0 : 1 + f(Array(l.dropFirst()))
    }}
    XCTAssertEqual(listcount([]), 0)
    XCTAssertEqual(listcount([1]), 1)
    XCTAssertEqual(listcount([1, 2]), 2)
    XCTAssertEqual(listcount(["1", "2"]), 2)
    XCTAssertEqual(listcount(["", "", 3]), 3)
    XCTAssertEqual(listcount(Array(1...100)), 100)
    XCTAssertEqual(listcount(Array(repeating: "1", count: 500)), 500)
  }

  func test_listsum() {
    let Y = YCombinatorFactory<[Int], Int>().Y
    let listsum = Y { (f) in { (l: [Int]) -> Int in
      l.isEmpty ? 0 : l[0] + f(Array(l.dropFirst()))
    }}
    XCTAssertEqual(listsum([]), 0)
    XCTAssertEqual(listsum([1]), 1)
    XCTAssertEqual(listsum([1, 2]), 3)
    XCTAssertEqual(listsum([1, 2, 3]), 6)
    XCTAssertEqual(listsum([1, 2, -3]), 0)
    XCTAssertEqual(listsum(Array(1...100)), 5050)
    XCTAssertEqual(listsum(Array(repeating: 1, count: 500)), 500)
  }

  static var allTests = [
    ("test_factorial", test_factorial),
    ("test_fibonachi", test_fibonachi),
    ("test_listcount", test_listcount),
    ("test_listsum", test_listsum),
  ]
}
