import XCTest
@testable import ZetConfig

class ZetConfigTests: XCTestCase {
  
  func testWritingConfigToFile() throws {
    let configPath = self.configPath
    try ZetConfig().write(to: configPath.path)
  }
  
  func testLoadingConfigFromFile() throws {
    let config = try ZetConfig.load(configPath.path)
    XCTAssertEqual(config, ZetConfig())
  }
  
  var thisDir: URL {
    URL.init(fileURLWithPath: #filePath).deletingLastPathComponent()
  }
 
  var configPath: URL {
    thisDir.appendingPathComponent("test-config.json")
  }
}
