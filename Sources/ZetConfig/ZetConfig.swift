import Foundation

public struct ZetConfig: Codable, Equatable {
  
  public var current: CurrentZets
  public var publicZets: String
  public var privateZets: String
  
  public init(
    current: CurrentZets = .public,
    publicZets: String = "~/zet",
    privateZets: String = "~/Private"
  ) {
    self.current = current
    self.publicZets = publicZets
    self.privateZets = privateZets
  }
  
  public enum CurrentZets: String, Codable, CaseIterable {
    case `public`
    case `private`
  }
}

extension ZetConfig {
  
  public static func load(
    _ url: URL,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    let data = try Data.init(contentsOf: url)
    let config = try decoder.decode(ZetConfig.self, from: data)
    return config
  }
  
  public static func load(
    _ path: String,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    let url = URL(fileURLWithPath: path)
    return try load(url, decoder: decoder)
  }
}

extension ZetConfig {
  
  public func write(
    to filePath: URL,
    encoder: JSONEncoder? = nil
  ) throws {
    let encoder = encoder ?? jsonEncoder
    let data = try encoder.encode(self)
    try data.write(to: filePath)
  }
  
  public func write(
    to filePath: String,
    encoder: JSONEncoder? = nil
  ) throws {
    try write(to: URL.init(fileURLWithPath: filePath), encoder: encoder)
  }
}

fileprivate let jsonEncoder: JSONEncoder = {
  let e = JSONEncoder()
  e.outputFormatting = [.prettyPrinted, .sortedKeys]
  return e
}()
