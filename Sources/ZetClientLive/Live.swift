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
//      lastModifiedDirectory: {
//        try fileManager.directories(in: zetDirectory)
//          .sorted(by: modificationDate(_:_:))
//          .first
//      },
      lastModified: { type in
        try fileManager.urls(for: type, in: zetDirectory)
          .sorted(by: modificationDate(_:_:))
          .first
      },
      makeZet: { title in
        let dir = try fileManager.createZetDirectory(in: zetDirectory)
        return try fileManager.createReadme(in: dir, titled: title)
      },
      makeAssetDirectory: { path in
        try fileManager.createAssets(in: path)
      },
      fetchTitle: { path in
        try path.readme.title()
      },
      titles: {
        let readmes = try fileManager.readmes(in: zetDirectory)
          .sorted(by: modificationDate(_:_:))
        let titles = try readmes.map { try $0.title() }
        return Array(zip(readmes, titles))
      }
    )
  }
}

public enum ZetClientError: Error {
  case titleNotFound(URL)
}
