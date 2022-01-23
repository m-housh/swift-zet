import XCTest
@testable import DirectoryClient

final class DirectoryClientTests: XCTestCase {
  
  func testDirectoryClient() throws {
    let zetDir = FileManager.default.temporaryDirectory.appendingPathComponent("directoryClientTest")
    try FileManager.default.createDirectory(at: zetDir, withIntermediateDirectories: true, attributes: nil)
    defer { try! FileManager.default.removeItem(at: zetDir) }
    
    let client = DirectoryClient.live(zetDirectory: zetDir)
    let readme = try client.create(.zet(titled: "Test-Zet")).get()
    let readmeParent = readme.deletingLastPathComponent()
    let assets = try client.create(.assets(parent: readmeParent)).get()
    
    XCTAssertEqual(
      try client.lastModified(.assets).get()
        .deletingLastPathComponent()
        .lastPathComponent,
      readmeParent.lastPathComponent
    )
    XCTAssertEqual(
      try client.lastModified(.directory).get().lastPathComponent,
      readmeParent.lastPathComponent
    )
    XCTAssertEqual(
      try client.lastModified(.readme).get()
        .deletingLastPathComponent()
        .lastPathComponent,
      readmeParent.lastPathComponent
    )
    
    let readmes = try client.list(.readmes).get()
    for readme in readmes {
      XCTAssert(readme.lastPathComponent == "README.md")
    }
    
    for asset in try client.list(.assets).get() {
      XCTAssert(asset.lastPathComponent == "assets")
    }
    
    XCTAssertEqual(readme.readme, readmeParent.readme)
    XCTAssertEqual(assets.assets.lastPathComponent, "assets")
    XCTAssertEqual(readmeParent.assets.lastPathComponent, "assets")
    
  }
}

