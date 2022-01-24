import Foundation

/// Represents the interactions / git commands performed on the zet repository.
public struct GitClient {
  
  public var handle: (GitRequest) -> Result<String, Error>
  
  public enum GitRequest {
    case add
    case commit(message: String)
    case grep(search: String)
    case lastMessage
    case pull
    case push
    case status
  }
}
