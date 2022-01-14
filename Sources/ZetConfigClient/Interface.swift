import Foundation
@_exported import ZetConfig

/// Represents interactions with a ``ZetConfig`` file.
public struct ZetConfigClient {
  
  /// Write the data to the file url.
  var writeData: (Data, URL) throws -> ()
  
  /// Read the data from the file url.
  var readData: (URL) throws -> Data
  
  /// Create a new ``ZetConfigClient``.
  ///
  /// - Parameters:
  ///   - writeData: Write the data to the file url.
  ///   - readData: Read the data from the file url.
  public init(
    writeData: @escaping (Data, URL) throws -> (),
    readData: @escaping (URL) throws -> Data
  ) {
    self.writeData = writeData
    self.readData = readData
  }
  
  /// Write a ``ZetConfig`` file to the given url.
  ///
  /// - Parameters:
  ///   - config: The ``ZetConfig`` to write to the file url.
  ///   - file: The file url to write the config to.
  ///   - encoder: An optional json encoder for the configuration file.
  public func write(
    config: ZetConfig,
    to file: URL,
    encoder: JSONEncoder? = nil
  ) throws {
    let encoder = encoder ?? jsonEncoder
    try writeData(encoder.encode(config), file)
  }
  
  /// Read a ``ZetConfig`` file from the given url.
  ///
  /// - Parameters:
  ///   - file: The file url to read the config from.
  ///   - decoder: An optional json decoder for the configuration file.
  public func read(
    from file: URL,
    decoder: JSONDecoder = .init()
  ) throws -> ZetConfig {
    try decoder.decode(ZetConfig.self, from: readData(file))
  }
}

/// The default json encoder used if not supplied when writing a configuration file.
fileprivate let jsonEncoder: JSONEncoder = {
  let e = JSONEncoder()
  e.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
  return e
}()
