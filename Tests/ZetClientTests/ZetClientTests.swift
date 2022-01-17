import XCTest
import ZetClient
@testable import ZetClientLive

final class ZetClientTests: XCTestCase {
 
  func testZetClient() throws {
    let zetClient = try ZetClient.testing()
    defer { try? zetClient.deleteZetDir() }
    let zet = try zetClient.createZet(title: "Test")
    XCTAssert(FileManager.default.fileExists(atPath: zet.relativePath))
    
    let last = try zetClient.lastModifiedDirectory()
    XCTAssertNotNil(last)
    let zetDir = zet.deletingLastPathComponent()
    XCTAssertEqual(last?.lastPathComponent, zetDir.lastPathComponent)
    
    let title = try zetClient.title(in: zet)
    XCTAssertEqual(title, "Test")
    XCTAssertEqual(try zetClient.title(in: zet.deletingLastPathComponent()), title)
    
    let assets = try zetClient.createAssets(in: zet.deletingLastPathComponent())
    XCTAssertEqual(assets.deletingLastPathComponent(), zetDir)
    
  }
  
//  func testTitles() throws {
//    let zetClient = try ZetClient.testing()
//    defer { try? zetClient.deleteZetDir() }
//    
//    for i in 0...3 {
//      let title = "# Test - \(i)\n\n"
//      let timeInterval = TimeInterval(i)
//      let dirName = zetClient.zetDirectory()
//        .appendingPathComponent(
//          (Date().addingTimeInterval(timeInterval)).isosec
//        )
//      try FileManager.default
//        .createDirectory(
//          atPath: dirName.relativePath,
//          withIntermediateDirectories: true,
//          attributes: nil
//        )
//      let readme = dirName.appendingPathComponent("README.md")
//      try title.write(to: readme, atomically: true, encoding: .utf8)
//    }
//    
//    let titles = try zetClient.titles()
//    print(titles)
//    XCTAssertEqual(titles.count, 3)
//  }
  
}

extension ZetClient {
  
  static func testing() throws -> Self {
    let dir = FileManager.default.temporaryDirectory
    let unique = dir.appendingPathComponent(UUID().uuidString)
    try FileManager.default.createDirectory(atPath: unique.relativePath, withIntermediateDirectories: true, attributes: nil)
    return try ZetClient.live(zetDirectory: dir)
  }
  
  func deleteZetDir() throws {
    try FileManager.default.removeItem(atPath: zetDirectory().relativePath)
  }
}
