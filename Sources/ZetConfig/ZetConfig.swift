import Foundation

/// Represents a configuration file for the ``zet`` command.
public struct ZetConfig: Codable, Equatable {
  
  /// The parent directory of the zettelkasten notes.
  public var zetDirectory: String
  
  /// Create a new ``ZetConfig``.
  ///
  /// - Parameters:
  ///   - zetDirectory: The parent directory of the zettelkasten notes.
  public init(
    zetDirectory: String = "~/zets"
  ) {
    self.zetDirectory = zetDirectory
  }
  
  /// Create a url from the zet directory path and ensures that it exists.
  public func zetURL() throws -> URL {
    let string = NSString(string: zetDirectory).expandingTildeInPath
    let url = URL(fileURLWithPath: string)
    if !FileManager.default.fileExists(atPath: url.relativePath) {
      throw ZetDirectoryError.directoryNotFound(zetDirectory)
    }
    return url
  }
}

public enum ZetDirectoryError: Error {
  case directoryNotFound(String)
}
