import XCTest
import ZetClient
@testable import ZetClientLive

final class ZetClientTests: XCTestCase {
 
  func testZetClient() throws {
    let zetClient = try ZetClient.testing()
    
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
    
    let titles = try zetClient.titles()
    XCTAssert(titles.count > 0) // kind of a poor test, but the test directory
    
  }
  
  func testReadmesTitlesAndAssets() throws {
    let zetClient = try ZetClient.testing()
    let testDir = zetClient.zetDirectory().appendingPathComponent("testReadmes")
    defer { try? FileManager.default.removeItem(atPath: testDir.relativePath) }
    
    try! FileManager.default.createDirectory(atPath: testDir.relativePath, withIntermediateDirectories: true, attributes: nil)
    for i in 0...3 {
      let title = "# Test - \(i)\n\n"
      let dir = try! FileManager.default.createZetDirectory(in: testDir, date: Date().advanced(by: .init(i)))
      _ = try! FileManager.default.createReadme(in: dir, titled: title)
      _ = try! FileManager.default.createAssets(in: dir)
    }
    
    let readmes = try FileManager.default.readmes(in: testDir)
    XCTAssertEqual(readmes.count, 4)
    
    let titles = try readmes.map { try $0.title() }
    XCTAssertEqual(titles.count, 4)
    
    let assets = try FileManager.default.assets(in: testDir)
    XCTAssertEqual(assets.count, 4)
  }
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
