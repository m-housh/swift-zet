import Foundation

public struct ZetConfig: Codable, Equatable {
  public var zetDirectory: String
  
  public init(
    zetDirectory: String = "~/zets"
  ) {
    self.zetDirectory = zetDirectory
  }
  
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
