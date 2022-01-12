import XCTest
import ZetConfig
@testable import ZetConfigClient

final class ZetConfigClientTests: XCTestCase {
  
  func testZetConfigClient() throws {
    let capturing = CapturingConfigData()
    let client = ZetConfigClient.testing(capturing)
    let url = FileManager.default.temporaryDirectory.appendingPathComponent("config.json")
    let config = ZetConfig()
    try client.write(config: config, to: url)
    
    XCTAssertEqual(url, capturing.url)
    
    let loaded = try client.read(from: url)
    XCTAssertEqual(loaded, config)
  }
  
  func testZetConfigClientLive() throws {
    let client = ZetConfigClient.live
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("parent")
      .appendingPathComponent("config.json")
    let config = ZetConfig()
    try client.write(config: config, to: url)
    
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.relativePath))
    
    let read = try client.read(from: url)
    XCTAssertEqual(read, config)
  }
  
  func testEnsureParentPath() throws {
    let url = FileManager.default.temporaryDirectory
      .appendingPathComponent("some")
      .appendingPathComponent("really")
      .appendingPathComponent("long")
      .appendingPathComponent("path")
      .appendingPathComponent("config.json")
    
    try url.ensureParentPath()
    XCTAssert(FileManager.default.fileExists(atPath: url.deletingLastPathComponent().relativePath))
    
    // ensure doing multiple times is not problematic
    try url.ensureParentPath()
    XCTAssert(FileManager.default.fileExists(atPath: url.deletingLastPathComponent().relativePath))
  }
  
  func testZetURLDoesNotThrowErrorWhenDirectoryExists() throws {
    let config = ZetConfig.init(zetDirectory: "/tmp")
    let url = try config.zetURL()
    XCTAssertTrue(FileManager.default.fileExists(atPath: url.relativePath))
  }
  
  func testZetURLThrowsErrorIfDirectoryDoesNotExist() throws {
    let config = ZetConfig.init(zetDirectory: "/some/path/that/does/not/exist")
    XCTAssertThrowsError(try config.zetURL())
  }
  
}

class CapturingConfigData {
  var url: URL?
  var data: Data?
  
  init() { }
  
  func write(_ data: Data, _ url: URL) throws {
    self.url = url
    self.data = data
  }
  
  func read(_ url: URL) throws -> Data {
    guard let data = data else {
      XCTFail("Data not set")
      fatalError()
    }
    return data
  }
}

extension ZetConfigClient {
  static func testing(_ capturing: CapturingConfigData) -> Self {
    .init(writeData: capturing.write(_:_:), readData: capturing.read(_:))
  }
}
