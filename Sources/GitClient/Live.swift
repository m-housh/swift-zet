import Foundation
import ShellCommand

extension GitClient {
  
  /// Creates the live ``GitClient`` for the given zet directory.
  ///
  /// -  Parameters:
  ///   - zetDirectory: The directory / repository that holds the zettelkasten notes.
  public static func live(zetDirectory: URL) -> GitClient {
    .init(
      add: {
        try ShellCommand(command: "git add --all")
          .run(in: zetDirectory)
      },
      commit: { message in
        try ShellCommand(command: "git commit -a -m \(message)")
          .run(in: zetDirectory)
      },
      grep: { search in
        try ShellCommand(command: "git grep -i --heading \(search)")
          .run(in: zetDirectory)
      },
      lastMessage: {
        try ShellCommand(command: "git log -n 1 --format=%s")
          .run(in: zetDirectory)
      },
      pull: {
        try ShellCommand(command: "git pull")
          .run(in: zetDirectory)
      },
      push: {
        try ShellCommand(command: "git push")
          .run(in: zetDirectory)
      }
    )
  }
}
