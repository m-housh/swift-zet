import Foundation
import ShellCommand

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

extension GitClient.GitRequest {
  
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

