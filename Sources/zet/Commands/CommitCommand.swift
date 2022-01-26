import ArgumentParser
import Foundation
import GitClient
import ZetClient

struct CommitCommand: ParsableCommand {
  
  private static let discussion = """
  If you would like to use the last commit message then you can supply the flag `--last` or `-l`.
  
  You can also use `zet commit last` or `zet commit` without a message to accomplish the same thing.
  
  """
  
  static let configuration: CommandConfiguration = .init(
    commandName: "commit",
    abstract: "Commit the zets to git.",
    discussion: discussion,
    version: VERSION ?? "0.0.0",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  @Flag(inversion: .prefixedNo, help: "Add all files to the commit")
  var add: Bool = true
  
  @Flag(inversion: .prefixedNo, help: "Enable or disable pushing to remote")
  var push: Bool = true
  
  @Flag(name: .shortAndLong, help: "Use the last commit message as the message for this commit.")
  var last: Bool = false
  
  @Argument var message: [String] = []
  
  func run() throws {
    
    try directoryOption.zetClient()
      .parseCommitMessage(message: message, last: last)
      .addToGit(shouldAdd: add)
      .commit()
      .push(shouldPush: push)
      .print()
    
  }
}

extension Result where Success == ZetClient, Failure == Error {
  
  func parseCommitMessage(message: [String], last: Bool) -> Result<(ZetClient, String), Error> {
    flatMap { client in
      if last == true || (message.count == 1 && message.first?.lowercased() == "last") {
        return client.git(.lastMessage)
          .map { (client, $0) }
      }
      return .success((client, message.joined(separator: " ")))
    }
  }
}

extension Result where Success == (ZetClient, String), Failure == Error {
  
  func addToGit(shouldAdd: Bool) -> Self {
    flatMap { client, _ in
      if shouldAdd {
        return client.git(.add).flatMap { _ in self }
      }
      return self
    }
  }
  
  func commit() -> Self {
    flatMap { client, message in
      client.git(.commit(message: message))
        .map { (client, $0) }
    }
  }
  
  
  
  func push(shouldPush: Bool) -> Result<String, Error> {
    flatMap { client, message in
      if shouldPush {
        return client.git(.push).map { _ in message }
      }
      return .success(message)
    }
  }
}
