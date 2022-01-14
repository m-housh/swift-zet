import Foundation

public struct GitClient {
  var _add: () throws -> Data
  var _commit: (String) throws -> Data
  var _lastMessage: () throws -> Data
  
  public init(
    add: @escaping () throws -> Data,
    commit: @escaping (String) throws -> Data,
    lastMessage: @escaping () throws -> Data
  ) {
    self._add = add
    self._commit = commit
    self._lastMessage = lastMessage
  }
  
  @discardableResult
  public func add() throws -> String {
    try _add().shellOutput()
  }
  
  @discardableResult
  public func commit(message: String?) throws -> String {
    var commitMessage: String
    if let message = message {
      commitMessage = message
    } else {
      commitMessage = try lastMessage()
    }
    return try _commit(commitMessage.quoted).shellOutput()
  }
  
  @discardableResult
  public func lastMessage() throws -> String {
    try _lastMessage().shellOutput()
  }
}
