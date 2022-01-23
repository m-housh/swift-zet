import Foundation
import ZetClient
import GitClient

extension Result {
  static func catching(_ result: @escaping () throws -> Success) -> Self where Failure == Error {
    .init(catching: result)
  }
}

extension Date {
  
  /// Attempts to create a date from an isosec string.
  init?(isosec: String) {
    guard let date = isosecFormatter.date(from: isosec) else {
      return nil
    }
    self = date
  }
  
  /// Create an isosec string from the date.
  var isosec: String {
    isosecFormatter.string(from: self)
  }
}

extension URL {
  
  /// Get the modification date of the item at the url.
  var modificationDate: Date? {
    try? resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
  }
  
  /// Appends `README.md` to a url if it doesn't already end with it.
  var readme: URL {
    if lastPathComponent != "README.md" {
      return self.appendingPathComponent("README.md")
    }
    return self
  }
  
  /// Appends `assets` to a url if it doesn't already end with it.
  var assets: URL {
    if lastPathComponent != "assets" {
      return self.appendingPathComponent("assets")
    }
    return self
  }
  
  /// Reads the title string from a readme file.
  func title() throws -> String {
    let fileString = try String(contentsOf: self)
    guard let titleLine = fileString.split(separator: "\n")
            .first(where: { $0.starts(with: "#") })
    else { throw ZetClientError.titleNotFound(self) }
    return titleLine.replacingOccurrences(of: "# ", with: "")
  }
}

/// Sorts urls descending, by their modification date.
///
/// - Parameters:
///   - lhs: The lhs url to check.
///   - rhs: The rhs url to check.
func modificationDate(_ lhs: URL, _ rhs: URL) -> Bool {
  guard let lhsMod = lhs.modificationDate,
        let rhsMod = rhs.modificationDate
  else {  return false }
  return lhsMod > rhsMod
}

extension FileManager {
  
  /// Get only directories under the given path, skipping any hidden directories.
  ///
  /// - Parameters:
  ///   - path: The path to get the sub-directories under.
  func directories(in path: URL) throws -> [URL] {
    try contentsOfDirectory(
      at: path,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: .skipsHiddenFiles
    )
      .filter {
        try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
      }
  }
  
  /// Creates a sub-directory in the path, using the ``Date.isosec`` for the directory name.
  ///
  /// - Parameters:
  ///   - path: The parent path to create the sub-directory in.
  @discardableResult
  func createZetDirectory(in path: URL, date: Date = Date()) throws -> URL {
    let dir = path.appendingPathComponent(date.isosec)
    try createDirectory(
      atPath: dir.relativePath,
      withIntermediateDirectories: false,
      attributes: nil
    )
    return dir
  }
  
  /// Returns the urls to all the readme files in the zet directory.
  ///
  /// - Parameters:
  ///   - path: The parent path to find the readme's in.
  func readmes(in path: URL) throws -> [URL] {
    try directories(in: path)
      .compactMap { directory in
        let readme = directory.readme
        guard isReadableFile(atPath: readme.relativePath) else { return nil }
        return readme
      }
  }
  
  /// Returns the urls to all the assets directories in the zet directory.
  ///
  /// - Parameters:
  ///   - path: The parent path to find the  assets in.
  func assets(in path: URL) throws -> [URL] {
    try directories(in: path)
      .compactMap { directory in
        try directories(in: directory)
          .first(where: { $0.lastPathComponent == "assets" })
      }
  }
  
  @discardableResult
  func createReadme(in path: URL, titled title: String) throws -> URL {
    let readme = path.readme
    try "# \(title)\n\n".write(to: readme, atomically: true, encoding: .utf8)
    return readme
  }
  
  @discardableResult
  func createAssets(in path: URL) throws -> URL {
    let assets = path.assets
    try createDirectory(atPath: assets.relativePath, withIntermediateDirectories: true, attributes: nil)
    return assets
  }
  
  func urls(for type: ZetClient.LastModifiedType, in zetDirectory: URL) throws -> [URL] {
    switch type {
    case .assets:
      return try assets(in: zetDirectory)
    case .directory:
      return try directories(in: zetDirectory)
    case .readme:
      return try readmes(in: zetDirectory)
    }
  }
}

extension ZetClient2.LastModifiedRequest {
  
  private func urls(zetDirectory: URL, fileManager: FileManager) throws -> [URL] {
    switch self {
    case .assets:
      return try fileManager.assets(in: zetDirectory)
    case .directory:
      return try fileManager.directories(in: zetDirectory)
    case .readme:
      return try fileManager.readmes(in: zetDirectory)
    }
  }
  
  func handle(zetDirectory: URL, fileManager: FileManager) -> Result<URL?, Error> {
    .catching {
      try urls(zetDirectory: zetDirectory, fileManager: fileManager)
        .sorted(by: modificationDate(_:_:))
        .first
    }
  }
}

extension ZetClient2.CreateRequest {
  
  struct AssetsPathNotFound: Error { }
  
  func findAssetsPath(zetDirectory: URL, fileManager: FileManager) throws -> URL? {
    try ZetClient2.LastModifiedRequest.directory
      .handle(zetDirectory: zetDirectory, fileManager: fileManager)
      .get()
  }
  
  func assetsPath(_ path: URL?, zetDirectory: URL, fileManager: FileManager) throws -> URL {
    guard let path = path else {
      guard let path = try findAssetsPath(zetDirectory: zetDirectory, fileManager: fileManager) else {
        throw AssetsPathNotFound()
      }
      return path
    }
    return path
  }
  
  func handle(zetDirectory: URL, fileManager: FileManager) -> Result<URL, Error> {
    switch self {
    case let .assets(path):
      return .catching {
        try fileManager
          .createAssets(in: assetsPath(path, zetDirectory: zetDirectory, fileManager: fileManager))
      }
    case let .directory(date):
      return .catching {
        try fileManager.createZetDirectory(in: zetDirectory, date: date ?? .init())
      }
    case let .zet(title):
      return .catching {
        try fileManager.createReadme(in: zetDirectory, titled: title)
      }
    }
  }
}


/// The format for an `isosec` string or date.
fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()
