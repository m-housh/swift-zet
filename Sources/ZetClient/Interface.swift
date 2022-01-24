import Foundation
import DirectoryClient
import GitClient

/// Represents interactions with the zet directory and sub-directories.
public struct ZetClient {
  
  public var zetDirectory: URL
  
  public var create: (DirectoryClient.CreateRequest) -> Result<URL, Error>
  public var git: (GitClient.GitRequest) -> Result<String, Error>
  public var lastModified: (DirectoryClient.LastModifiedRequest) -> Result<URL, Error>
  public var list: (DirectoryClient.ListRequest) -> Result<[URL], Error>
  
  public init(
    zetDirectory: URL,
    create: @escaping (DirectoryClient.CreateRequest) -> Result<URL, Error>,
    git: @escaping (GitClient.GitRequest) -> Result<String, Error>,
    lastModified: @escaping (DirectoryClient.LastModifiedRequest) -> Result<URL, Error>,
    list: @escaping (DirectoryClient.ListRequest) -> Result<[URL], Error>
  ) {
    self.zetDirectory = zetDirectory
    self.create = create
    self.git = git
    self.lastModified = lastModified
    self.list = list
  }
}
