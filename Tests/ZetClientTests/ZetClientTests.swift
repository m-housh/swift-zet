import XCTest
import ZetClient
import ZetClientLive

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
    
    let assets = try zetClient.makeAssets(in: zet.deletingLastPathComponent())
    XCTAssertEqual(assets.deletingLastPathComponent(), zetDir)
    
  }
  
}

extension ZetClient {
  
  static func testing() throws -> Self {
    let dir = FileManager.default.temporaryDirectory
    return try ZetClient.live(zetDirectory: dir)
  }
  
  func deleteZetDir() throws {
    try FileManager.default.removeItem(atPath: zetDirectory().relativePath)
  }
}
