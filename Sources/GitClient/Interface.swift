import Foundation

/// Represents the interactions / git commands performed on the zet repository.
public struct GitClient {
  
  /// Add files to be tracked in `git`.
  var _add: () throws -> Data
  
  /// Commit the working tree and files to `git`.
  var _commit: (String) throws -> Data
  
  /// Search the working tree.
  var _grep: (String) throws -> Data
  
  /// Retrieve the last `git` commit message used.
  var _lastMessage: () throws -> Data
  
  /// Pull commits from the remote.
  var _pull: () throws -> Data
  
  /// Push commits to the remote.
  var _push: () throws -> Data
  
  /// Create a new ``GitClient``.
  ///
  /// - Parameters:
  ///   - add: Add files to be tracked in `git`.
  ///   - commit: Commit the working tree and files to `git`.
  ///   - lastMessage: Retrieve the last `git` commit message used.
  ///   - pull: Pull commits from the remote.
  ///   - push: Push commits to the remote.
  public init(
    add: @escaping () throws -> Data,
    commit: @escaping (String) throws -> Data,
    grep: @escaping (String) throws -> Data,
    lastMessage: @escaping () throws -> Data,
    pull: @escaping () throws -> Data,
    push: @escaping () throws -> Data
  ) {
    self._add = add
    self._commit = commit
    self._grep = grep
    self._lastMessage = lastMessage
    self._pull = pull
    self._push = push
  }
  
  /// Add files to be tracked in `git`.
  @discardableResult
  public func add() throws -> String {
    try _add().shellOutput()
  }
  
  /// Commit the working tree and files to `git`.
  ///
  /// - Parameters:
  ///   - message: The commit message to use, if not supplied then attempts to use the last commit message.
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
  
  /// Search the `git` files for the given string.
  @discardableResult
  public func grep(search: String) throws -> String {
    try _grep(search).shellOutput()
  }
 
  /// Retrieve the last `git` commit message used.
  @discardableResult
  public func lastMessage() throws -> String {
    try _lastMessage().shellOutput()
  }
 
  /// Pull commits from the remote.
  @discardableResult
  public func pull() throws -> String {
    try _pull().shellOutput()
  }
  
  /// Push commits to the remote.
  @discardableResult
  public func push() throws -> String {
    try _push().shellOutput()
  }
}
