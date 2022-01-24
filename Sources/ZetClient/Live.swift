import DirectoryClient
import Foundation
import GitClient

extension ZetClient {
  
  public static func live(
    zetDirectory: URL,
    fileManager: FileManager = .default,
    directoryClient: DirectoryClient? = nil,
    gitClient: GitClient? = nil
  ) -> ZetClient {
    
    let directoryClient = directoryClient ??
      .live(zetDirectory: zetDirectory, fileManager: fileManager)
    
    let gitClient = gitClient ??
      .live(zetDirectory: zetDirectory, environment: nil)
    
    return .init(
      zetDirectory: zetDirectory,
      create: { directoryClient.create($0) },
      git: { gitClient.handle($0) },
      lastModified: { directoryClient.lastModified($0) },
      list: { directoryClient.list($0) }
    )
  }
}
