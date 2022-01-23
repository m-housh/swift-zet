import Foundation

/// Responsible for interactions with zet directory.  Handles file management tasks, such as creating
/// directories and files.
public struct DirectoryClient {
  
  public var create: (CreateRequest) -> Result<URL, Error>
  public var lastModified: (LastModifiedRequest) -> Result<URL, Error>
  public var list: (ListRequest) -> Result<[URL], Error>
  
  public init(
    create: @escaping (CreateRequest) -> Result<URL, Error>,
    lastModified: @escaping (LastModifiedRequest) -> Result<URL, Error>,
    list: @escaping (ListRequest) -> Result<[URL], Error>
  ) {
    self.create = create
    self.lastModified = lastModified
    self.list = list
  }
  
  public enum CreateRequest {
    case assets(parent: URL)
    case zet(titled: String)
  }
  
  public enum LastModifiedRequest: String {
    case assets
    case directory
    case readme
  }
  
  public enum ListRequest: String {
    case assets
    case directories
    case readmes
  }
}
