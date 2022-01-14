import Foundation

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
  func zetDirectory(in path: URL) throws -> URL {
    let dir = path.appendingPathComponent(Date().isosec)
    try createDirectory(
      atPath: dir.relativePath,
      withIntermediateDirectories: false,
      attributes: nil
    )
    return dir
  }
}

/// The format for an `isosec` string or date.
fileprivate let isosecFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()
