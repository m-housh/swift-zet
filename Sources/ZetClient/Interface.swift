import Foundation

public struct ZetClient {
  
  public var zetDirectory: () -> URL
  public var lastModifiedDirectory: () throws -> URL?
  public var makeZet: (String) throws -> URL
  public var makeAssetDirectory: (URL) throws -> URL
  public var fetchTitle: (URL) throws -> String
  
  public init(
    zetDirectory: @escaping () -> URL,
    lastModifiedDirectory: @escaping () throws -> URL?,
    makeZet: @escaping (String) throws -> URL,
    makeAssetDirectory: @escaping (URL) throws -> URL,
    fetchTitle: @escaping (URL) throws -> String
  ) {
    self.zetDirectory = zetDirectory
    self.lastModifiedDirectory = lastModifiedDirectory
    self.makeZet = makeZet
    self.makeAssetDirectory = makeAssetDirectory
    self.fetchTitle =  fetchTitle
  }
  
  @discardableResult
  public func createZet(title: String) throws -> URL {
    try makeZet(title)
  }
  
  @discardableResult
  public func makeAssets(in directory: URL) throws -> URL {
    try makeAssetDirectory(directory)
  }
  
  public func title(in path: URL) throws -> String {
    try fetchTitle(path)
  }
}
