import XCTest
@testable import ZetManager

final class ZetManagerTests: XCTestCase {
  
  func testMakeZetDirectory() throws {
    let manager = try ZetManager.testing()
    defer { try! manager.removeDir() }
    let zetDir = try manager.makeZetDirectory()
    let last = try manager.lastModifiedDirectory()
    XCTAssertNotNil(last)
    // Full path does not work here, the last directory will be in /private/var...
    // while  the zet dir will be /var... (leaves off the /private for some reason)
    XCTAssertEqual(last!.lastPathComponent, zetDir.lastPathComponent)
  }

  func testMakeZet() throws {
    let manager = try ZetManager.testing()
    defer { try! manager.removeDir() }
    let readme = try manager.makeZet(titled: "Test")
    let content = try String(contentsOf: readme)
    XCTAssertEqual(content, "# Test\n\n")
  }
  
  func testMakeAssetDirectory() throws {
    let manager = try ZetManager.testing()
    defer { try! manager.removeDir() }
    
    for title in ["Foo", "Bar", "Baz"] {
      _ = try manager.makeZet(titled: title)
      // have to sleep so that makeZet works, otherwise the isosec for
      // the directories collide.
      sleep(1)
    }
    
    let last = try manager.lastModifiedDirectory()
    XCTAssertNotNil(last)
    
    let assets = try manager.makeAssetDirectory(in: last!)
    XCTAssert(FileManager.default.fileExists(atPath: assets.relativePath))
  }
  
  func testTitle() throws {
    let manager = try ZetManager.testing()
    defer { try! manager.removeDir() }
    let readme = try manager.makeZet(titled: "Test")
    let dir = readme.deletingLastPathComponent()
    let title =  try manager.title(dir)
    XCTAssertEqual(title, "Test")
  }
}

extension ZetManager {
  
  func removeDir() throws {
    try manager.removeItem(at: directory)
  }
  
  static func testing() throws -> ZetManager {
    // create a unique dir.
    let tempDir = FileManager.default
      .temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
    
    try FileManager.default.createDirectory(
      atPath: tempDir.relativePath,
      withIntermediateDirectories: true,
      attributes: nil
    )
    return .init(tempDir)
  }
}
