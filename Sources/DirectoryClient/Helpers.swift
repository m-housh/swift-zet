import Foundation

extension URL {
  
  var assets: URL {
    if self.lastPathComponent == "assets" {
      return self
    }
    return self.appendingPathComponent("assets")
  }
  
  /// Get the modification date of the item at the url.
  var modificationDate: Date? {
    try? resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate
  }
  
  var readme: URL {
    if self.lastPathComponent == "README.md" {
      return self
    }
    return self.appendingPathComponent("README.md")
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
  
  func createDirectory(path: URL, intermediates: Bool = false) -> Result<URL, Error> {
    Result {
      try createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
      return path
    }
  }
  
  /// Get only directories under the given path, skipping any hidden directories.
  ///
  /// - Parameters:
  ///   - path: The path to get the sub-directories under.
  func directories(in path: URL) -> Result<[URL], Error> {
    Result {
      try contentsOfDirectory(
        at: path,
        includingPropertiesForKeys: [.isDirectoryKey],
        options: .skipsHiddenFiles
      )
        .filter {
          try $0.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true
        }
    }
  }
}

extension Result where Success == URL, Failure == Error {
  
  func createReadme(titled title: String) -> Self {
    flatMap { parent in
      Result {
        let readme = parent.readme
        try "# \(title)\n\n".write(to: readme, atomically: true, encoding: .utf8)
        return readme
      }
    }
  }
}

struct NotFoundError: Error { }

extension Result where Success == [URL], Failure == Error {
  
  func sortedByModificationDate() -> Self {
    map { urls in
      urls.sorted(by: modificationDate(_:_:))
    }
  }
  
  func assetDirectories(fileManager: FileManager) -> Self {
    map { parents in
      parents.compactMap { parent in
        let assets = parent.assets
        guard fileManager.fileExists(atPath: assets.path) else {
          return nil
        }
        return assets
      }
    }
  }
  
  func readmes(fileManager: FileManager) -> Self {
    map { parents in
      parents.compactMap { parent in
        let readme = parent.readme
        guard fileManager.isReadableFile(atPath: readme.path) else {
          return nil
        }
        return readme
      }
    }
  }
  
  func first() -> Result<URL?, Error> {
    map { $0.first }
  }
}

extension Result where Success == Optional<URL>, Failure == Error {
  
  func unwrap() -> Result<URL, Error> {
    flatMap { optionalUrl in
      switch optionalUrl {
      case .none:
        return .failure(NotFoundError())
      case .some(let wrapped):
        return .success(wrapped)
      }
    }
  }
}

extension DirectoryClient.CreateRequest {
  
  static func handler(zetDirectory: URL, fileManager: FileManager) -> (Self) -> Result<URL, Error> {
    { request in
      switch request {
        
      case let .assets(parent: parent):
        return fileManager
          .createDirectory(path: parent.assets, intermediates: false)
        
      case let .zet(titled: title):
        return fileManager
          .createDirectory(path: zetDirectory.appendingPathComponent(Date().isosec), intermediates: false)
          .createReadme(titled: title)
      }
    }
  }
}

extension DirectoryClient.ListRequest {
  
  static func handler(zetDirectory: URL, fileManager: FileManager) -> (Self) -> Result<[URL], Error> {
    { request in
      
      switch request {
        
      case .assets:
        return fileManager.directories(in: zetDirectory)
          .assetDirectories(fileManager: fileManager)
        
      case .directories:
        return fileManager.directories(in: zetDirectory)
        
      case .readmes:
        return fileManager.directories(in: zetDirectory)
          .readmes(fileManager: fileManager)
      }
    }
  }
}

extension DirectoryClient.LastModifiedRequest {
  
  var listRequest: DirectoryClient.ListRequest {
    switch self {
    case .assets: return .assets
    case .directory: return .directories
    case .readme: return .readmes
    }
  }
 
  static func handler(zetDirectory: URL, fileManager: FileManager) -> (Self) -> Result<URL, Error> {
    { request in
      // We use the list request handler to list the appropriate type for the
      // request, then sort them and return the first item or throw an error.
      DirectoryClient.ListRequest
        .handler(zetDirectory: zetDirectory, fileManager: fileManager)(request.listRequest)
        .sortedByModificationDate()
        .first()
        .unwrap()
    }
  }
}

extension Date {
  var isosec: String {
    isosecFormatter.string(from: self)
  }
}

/// The format for an `isosec` string or date.
fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()
