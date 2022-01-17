import Foundation
@_exported import ZetClient

extension ZetClient {
  
  /// Create the live ``ZetClient``.
  ///
  /// - Parameters:
  ///   - zetDirectory: The parent directory for the zettelkasten notes.
  ///   - fileManager: The file manager to use.
  public static func live(zetDirectory: URL, fileManager: FileManager = .default) throws -> ZetClient {
    .init(
      zetDirectory: { zetDirectory },
      lastModifiedDirectory: {
        try fileManager.directories(in: zetDirectory)
          .sorted(by: modificationDate(_:_:))
          .first
      },
      makeZet: { title in
        let dir = try fileManager.zetDirectory(in: zetDirectory)
        let readme = dir.appendingPathComponent("README.md")
        try "# \(title)\n\n".write(to: readme, atomically: true, encoding: .utf8)
        return readme
      },
      makeAssetDirectory: { path in
        let dir = path.appendingPathComponent("assets")
        try fileManager.createDirectory(
          atPath: dir.relativePath,
          withIntermediateDirectories: false,
          attributes: nil
        )
        return dir
      },
      fetchTitle: { path in
        try path.readme.title()
      },
      titles: {
        try fileManager.directories(in: zetDirectory)
          .sorted(by: modificationDate(_:_:))
          .map { parent -> URL? in
            let readme = parent.readme
            guard fileManager.isReadableFile(atPath: readme.relativePath) else {
              return nil
            }
            return readme
          }
          .compactMap { readme in
            guard let readme = readme,
                    let title = try? readme.title()
            else { return nil }
            return (readme, title)
          }
      }
    )
  }
}

public enum ZetClientError: Error {
  case titleNotFound(URL)
}
