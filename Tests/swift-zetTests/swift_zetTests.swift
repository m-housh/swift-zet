import XCTest
import class Foundation.Bundle
@testable import zet

final class swift_zetTests: XCTestCase {
  
  func testIsosec() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let date = formatter.date(from: "2022/01/01 12:00:00")!
    XCTAssertEqual(date.isosec, "20220101120000")
  }
  
  func testDateFromIsosec() {
    let isosec = "20220101120000"
    let date = Date(isosec: isosec)
    XCTAssertEqual(isosec, date!.isosec)
    
    XCTAssertNil(Date(isosec: "2022/01/01 12:00:00"))
  }
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//
//        // Some of the APIs that we use below are available in macOS 10.13 and above.
//        guard #available(macOS 10.13, *) else {
//            return
//        }
//
//        // Mac Catalyst won't have `Process`, but it is supported for executables.
//        #if !targetEnvironment(macCatalyst)
//
//        let fooBinary = productsDirectory.appendingPathComponent("zet")
//
//        let process = Process()
//        process.executableURL = fooBinary
//
//        let pipe = Pipe()
//        process.standardOutput = pipe
//
//        try process.run()
//        process.waitUntilExit()
//
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = String(data: data, encoding: .utf8)
//
//        XCTAssertEqual(output, "Hello, world!\n")
//        #endif
//    }
//
//    /// Returns path to the built products directory.
//    var productsDirectory: URL {
//      #if os(macOS)
//        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
//            return bundle.bundleURL.deletingLastPathComponent()
//        }
//        fatalError("couldn't find the products directory")
//      #else
//        return Bundle.main.bundleURL
//      #endif
//    }
}
