import Foundation

public struct ZetConfig2: Codable, Equatable {
  public var zetDirectory: URL
  
  public init(zetDirectory: URL) {
    self.zetDirectory = zetDirectory
  }
  
  public init(zetDirectory: String) {
    self.zetDirectory = URL(fileURLWithPath: NSString(string: zetDirectory).expandingTildeInPath)
  }
}

/// Represents the configuration for the ``zet`` application.
public struct ZetConfig: Codable, Equatable {
  
  /// The current working zet repository.
  public var current: CurrentZets
  
  /// The path to the public zet repository.
  public var publicZets: String
  
  /// The path to the private zet repository.
  public var privateZets: String
  
  /// Create a new ``ZetConfig`` with the default values.
  ///
  /// - Parameters:
  ///   - current: The ``CurrentZets`` that are active.
  ///   - publicZets: The path to the public zet repository.
  ///   - privateZets: The path to the private zet repository.
  public init(
    current: CurrentZets = .public,
    publicZets: String = "~/zet",
    privateZets: String = "~/Private"
  ) {
    self.current = current
    self.publicZets = publicZets
    self.privateZets = privateZets
  }
  
  /// Represents the currently active zet repository.
  public enum CurrentZets: String, Codable, CaseIterable {
    case `public`
    case `private`
  }
}

extension ZetConfig {
  
  /// Load a ``ZetConfig`` from a file path.
  ///
  /// - Parameters:
  ///   - url: The file path to load the zet config from.
  ///   - decoder: The ``JSONDecoder`` used to decode the zet config.
  public static func load(
    _ url: URL,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    let data = try Data.init(contentsOf: url)
    let config = try decoder.decode(ZetConfig.self, from: data)
    return config
  }
  
  /// Load a ``ZetConfig`` from a file path.
  ///
  /// - Parameters:
  ///   - path: The file path to load the zet config from.
  ///   - decoder:  The ``JSONDecoder`` used to decode the zet config.
  public static func load(
    _ path: String,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    let url = URL(fileURLWithPath: path)
    return try load(url, decoder: decoder)
  }
}

extension ZetConfig {
  
  /// Writes a ``ZetConfig`` to a file path.
  ///
  /// - Parameters:
  ///   - filePath: The file path to write the zet config from.
  ///   - encoder:  The ``JSONEecoder`` used to encode the zet config.
  public func write(
    to filePath: URL,
    encoder: JSONEncoder? = nil
  ) throws {
    let encoder = encoder ?? jsonEncoder
    let data = try encoder.encode(self)
    try data.write(to: filePath)
  }
  
  /// Writes a ``ZetConfig`` to a file path.
  ///
  /// - Parameters:
  ///   - filePath: The file path to write the zet config from.
  ///   - encoder:  Optional ``JSONEecoder`` used to encode the zet config.
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
