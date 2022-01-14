import Foundation

extension ZetConfigClient {
 
  /// Creates the live implementation of the ``ZetConfigClient``.
  public static let live = Self.init(
    writeData: { data, url in
      try url.ensureParentPath()
      try data.write(to: url)
    },
    readData: { url in
      try Data(contentsOf: url)
    }
  )
}

extension URL {
  
  /// Ensures that the parent directory exists, or attempts to create it if not.
  func ensureParentPath() throws {
    let parent = self.deletingLastPathComponent().relativePath
    if !FileManager.default.fileExists(atPath: parent) {
      try FileManager.default
        .createDirectory(atPath: parent, withIntermediateDirectories: true, attributes: nil)
    }
  }
}
