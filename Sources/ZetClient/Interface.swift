import Foundation

/// Represents interactions with the zet directory and sub-directories.
public struct ZetClient {
  
  /// The zet directory for the client.
  public var zetDirectory: () -> URL
  
  /// The last modified sub-directory in the zet directory.
  public var lastModifiedDirectory: () throws -> URL?
  
  /// Create a new zettelkasten note in the directory.
  var makeZet: (String) throws -> URL
  
  /// Create an `assets` directory in the given path.
  var makeAssetDirectory: (URL) throws -> URL
  
  /// Get the title of a zettelkasten note in the given path.
  var fetchTitle: (URL) throws -> String
  
  /// Get all the titles of the zets.
  public var titles: () throws -> [(URL, String)]
  
  /// Create a new ``ZetClient``.
  ///
  /// - Parameters:
  ///   - zetDirectory: The zet directory for the client.
  ///   - lastModifiedDirectory: The last modified sub-directory in the zet directory.
  ///   - makeZet: Create a new zettelkasten note in the directory.
  ///   - makeAssetDirectory: Create an `assets` directory in the given path.
  ///   - fetchTitle: Get the title of a zettelkasten note in the given path.
  public init(
    zetDirectory: @escaping () -> URL,
    lastModifiedDirectory: @escaping () throws -> URL?,
    makeZet: @escaping (String) throws -> URL,
    makeAssetDirectory: @escaping (URL) throws -> URL,
    fetchTitle: @escaping (URL) throws -> String,
    titles: @escaping () throws -> [(URL, String)]
  ) {
    self.zetDirectory = zetDirectory
    self.lastModifiedDirectory = lastModifiedDirectory
    self.makeZet = makeZet
    self.makeAssetDirectory = makeAssetDirectory
    self.fetchTitle =  fetchTitle
    self.titles = titles
  }
 
  /// Create a new zettelkasten note in the directory with the given title.
  ///
  /// - Parameters:
  ///   - title: The title for the zettelkasten note.
  @discardableResult
  public func createZet(title: String) throws -> URL {
    try makeZet(title)
  }
  
  /// Create an `assets` directory in the given path.
  ///
  /// - Parameters:
  ///   - directory: The directory to  create an `assets` directory in.
  @discardableResult
  public func createAssets(in directory: URL) throws -> URL {
    try makeAssetDirectory(directory)
  }
  
  /// Get the title of a zettelkasten note in the given path.
  ///
  /// - Parameters:
  ///   - path: The path to a find the title in.
  public func title(in path: URL) throws -> String {
    try fetchTitle(path)
  }
}
