import Foundation
@_exported import ZetConfig

public struct ZetConfigClient {
  var writeData: (Data, URL) throws -> ()
  var readData: (URL) throws -> Data
  
  public init(
    writeData: @escaping (Data, URL) throws -> (),
    readData: @escaping (URL) throws -> Data
  ) {
    self.writeData = writeData
    self.readData = readData
  }
  
  public func write(
    config: ZetConfig,
    to file: URL,
    encoder: JSONEncoder? = nil
  ) throws {
    let encoder = encoder ?? jsonEncoder
    try writeData(encoder.encode(config), file)
  }
  
  public func read(
    from file: URL,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    try decoder.decode(ZetConfig.self, from: readData(file))
  }
}

fileprivate let jsonEncoder: JSONEncoder = {
  let e = JSONEncoder()
  e.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
  return e
}()
