import Foundation
import ZetClient

extension ZetClient {
  
  public static func live(zetDirectory: URL, fileManager: FileManager = .default) throws -> ZetClient {
    .init(
      zetDirectory: { zetDirectory },
      lastModifiedDirectory: {
        try fileManager.directories(in: zetDirectory)
          .sorted { lhs, rhs in
            guard let lhsDate = lhs.modificationDate,
                  let rhsDate = rhs.modificationDate
            else { return false }
            return lhsDate > rhsDate
          }
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
        var path = path
        if path.lastPathComponent != "README.md" {
          path = path.appendingPathComponent("README.md")
        }
        let fileString = try String(contentsOf: path)
        guard let titleLine = fileString.split(separator: "\n").first else {
          // throw an error
          fatalError()
        }
        return titleLine.replacingOccurrences(of: "# ", with: "")
      }
    )
  }
}
