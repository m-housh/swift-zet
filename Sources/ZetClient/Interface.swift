import Foundation

/// Represents interactions with the zet directory and sub-directories.
public struct ZetClient {
  
  /// The zet directory for the client.
  public var zetDirectory: () -> URL
  
  /// The last modified type in the zet directory.
  public var lastModified: (LastModifiedType) throws -> URL?
  
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
  ///   - lastModified: The last modified type in the zet directory.
  ///   - makeZet: Create a new zettelkasten note in the directory.
  ///   - makeAssetDirectory: Create an `assets` directory in the given path.
  ///   - fetchTitle: Get the title of a zettelkasten note in the given path.
  public init(
    zetDirectory: @escaping () -> URL,
    lastModified: @escaping (LastModifiedType) throws -> URL?,
    makeZet: @escaping (String) throws -> URL,
    makeAssetDirectory: @escaping (URL) throws -> URL,
    fetchTitle: @escaping (URL) throws -> String,
    titles: @escaping () throws -> [(URL, String)]
  ) {
    self.zetDirectory = zetDirectory
    self.lastModified = lastModified
    self.makeZet = makeZet
    self.makeAssetDirectory = makeAssetDirectory
    self.fetchTitle =  fetchTitle
    self.titles = titles
  }
  
  public enum LastModifiedType {
    case assets, directory, readme
  }
  
  public enum ManageRequest {
    case add
    case commit
    case grep
    case lastMessage
    case pull
    case push
    case status
  }
  
  public enum CreateRequest {
    case assets
    case zet(titled: String)
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

public struct ZetClient2 {
  
  public var zetDirectory: URL
  
  public var create: (CreateRequest) throws -> URL
  public var git: (GitRequest) throws -> String
  public var lastModified: (LastModifiedRequest) throws -> URL?
  
  public init(
    zetDirectory: URL,
    create: @escaping (CreateRequest) throws -> URL,
    git: @escaping (GitRequest) throws -> String,
    lastModified: @escaping (LastModifiedRequest) throws -> URL?
  ) {
    self.zetDirectory = zetDirectory
    self.create = create
    self.git = git
    self.lastModified = lastModified
  }
  
  public enum LastModifiedRequest {
    case assets, directory, readme
  }
  
  public enum GitRequest {
    case add
    case commit(message: String, add: Bool)
    case grep(search: String)
    case lastMessage
    case pull
    case push
    case status
  }
  
  public enum CreateRequest {
    case assets
    case zet(titled: String)
  }
  
}
