import Foundation

public struct ZetManager {
  
  let directory: URL
  let manager: FileManager
  
  public init(
    _ directory: URL,
    manager: FileManager = .default
  ) {
    self.directory = directory
    self.manager = manager
  }
  
  /// Performs a shallow search of the zet directory, returning only url's that are directories.
  public func directories() throws -> [URL] {
    return try manager.contentsOfDirectory(
      at: directory,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: .skipsHiddenFiles
    )
    .filter { try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true }
  }
  
  /// Returns the last modified directory in the zet directory.
  public func lastModifiedDirectory() throws -> URL? {
    try directories()
      .sorted { lhs, rhs in
        guard let lhsDate = lhs.modificationDate,
              let rhsDate = rhs.modificationDate
        else { return false }
        return lhsDate > rhsDate
      }
      .first
  }
  
  /// Creates a new zet directory based on the `isosec`.
  func makeZetDirectory() throws -> URL {
    let dir = directory.appendingPathComponent(Date().isosec)
    try manager.createDirectory(
      atPath: dir.relativePath,
      withIntermediateDirectories: false,
      attributes: nil
    )
    return dir
  }
  
  /// Creates a new zet directory and a readme file.
  ///
  /// - Parameters:
  ///   - title: The title to use for the new zet.
  public func makeZet(titled title: String) throws -> URL {
    let dir = try makeZetDirectory()
    let readme = dir.appendingPathComponent("README.md")
    try "# \(title)\n\n".write(to: readme, atomically: true, encoding: .utf8)
    return readme
  }
  
  /// Create an asset directory in the given path.
  ///
  /// - Parameters:
  ///   - path: The zet directory to create the asset directory in.
  @discardableResult
  public func makeAssetDirectory(in path: URL) throws -> URL {
    var assetDir = path
    if path.lastPathComponent != "assets" {
      assetDir = path.appendingPathComponent("assets")
    }
    try manager.createDirectory(
      atPath: assetDir.relativePath,
      withIntermediateDirectories: false,
      attributes: nil
    )
    return assetDir
  }
  
  /// Retrieve the title from the readme, removing the beginning "# ".
  ///
  /// - Parameters:
  ///   - readme: The path to the readme.
  public func title(readme: URL) throws -> String {
    guard manager.fileExists(atPath: readme.relativePath) else {
      throw ZetManagerError.notFound(readme)
    }
    guard manager.isReadableFile(atPath: readme.relativePath) else {
      throw ZetManagerError.notReadable(readme)
    }
    let string = try String(contentsOf: readme)
    guard let titleLine = string.split(separator: "\n").first else {
      throw ZetManagerError.titleNotFound(readme)
    }
    let title = titleLine.replacingOccurrences(of: "# ", with: "")
    return title
  }
  
  /// Retrieve the title from a readme, removing the beginning "# ".
  ///
  /// - Parameters:
  ///   - path: The path to the parent directory that holds the readme or path to the readme itself.
  public func title(_ path: URL) throws -> String {
    var path = path
    if path.lastPathComponent != "README.md" {
      path = path.appendingPathComponent("README.md")
    }
    return try title(readme: path)
  }
}

public enum ZetManagerError: Error {
  case notFound(URL)
  case notReadable(URL)
  case titleNotFound(URL)
}

extension URL {
  var modificationDate: Date? {
    try? resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
  }
}
