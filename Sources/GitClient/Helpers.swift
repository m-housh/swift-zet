import Foundation
import ShellCommand
import ZetClient

extension String {
  
  /// Creates a quoted version of string.
  var quoted: String {
    "\"\(self)\""
  }
}

extension Data {
  
  /// Convert a ``ShellCommand``'s output to a string.
  func shellOutput() -> String {
    guard let output = String(data: self, encoding: .utf8) else {
      return ""
    }
    return output
  }
}

extension ShellCommand {
  
  /// Runs the ``ShellCommand`` in the given directory.
  ///
  /// - Parameters:
  ///   - path: The directory to run the command in.
  ///   - environment: The environment variables for the command.
  func run(in path: URL, environment: [String: String]? = nil) throws -> Data {
    FileManager.default.changeCurrentDirectoryPath(path.path)
    return try run(environment: environment)
  }
}

extension ZetClient2.GitRequest.CommitRequest {
  
  func commitMessage(_ zetDirectory: URL, _ environment: [String: String]?) throws -> String {
    switch self {
    case .last:
      return try ZetClient2.GitRequest.lastMessage
        .run(in: zetDirectory, environment: environment)
        .get()
    case let .message(message):
      return message
    }
  }
}

extension GitClient2.GitRequest {
  
  var shellCommand: ShellCommand {
    switch self {
    case .add:
      return .init(command: "git add --all")
    case let .commit(message):
      return .init(command: "git commit -a -m \(message.quoted)")
    case .grep(search: let search):
      return .init(command: "git grep -i --heading \(search)")
    case .lastMessage:
      return .init(command: "git log -n 1 --format=%s")
    case .pull:
      return .init(command: "git pull")
    case .push:
      return .init(command: "git push")
    case .status:
      return .init(command: "git status")
    }
  }
}

extension ZetClient2.GitRequest {
  
  func shellCommand(_ zetDirectory: URL, _ environment: [String: String]? = nil) throws -> ShellCommand {
    switch self {
    case .add:
      return .init(command: "git add --all")
    case let .commit(request, shouldAdd):
      if shouldAdd {
        _ = try Self.add
          .run(in: zetDirectory, environment: environment)
          .get()
      }
      let message = try request.commitMessage(zetDirectory, environment)
      return .init(command: "git commit -a -m \(message.quoted)")
    case let .grep(search: search):
      return .init(command: "git grep -i --heading \(search)")
    case .lastMessage:
      return .init(command: "git log -n 1 --format=%s")
    case .pull:
      return .init(command: "git pull")
    case .push:
      return .init(command: "git push")
    case .status:
      return .init(command: "git status")
    }
  }
  
  func run(in zetDirectory: URL, environment: [String: String]? = nil) -> Result<String, Error> {
    .init {
      try self.shellCommand(zetDirectory)
        .run(in: zetDirectory, environment: environment)
        .shellOutput()
    }
  }
}
