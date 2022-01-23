import Foundation

extension DirectoryClient {
  
  public static func live(zetDirectory: URL, fileManager: FileManager = .default) -> Self {
    .init(
      create: CreateRequest.handler(zetDirectory: zetDirectory, fileManager: fileManager),
      lastModified: LastModifiedRequest.handler(zetDirectory: zetDirectory, fileManager: fileManager),
      list: ListRequest.handler(zetDirectory: zetDirectory, fileManager: fileManager)
    )
  }
}
