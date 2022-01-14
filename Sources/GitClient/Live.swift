import Foundation
import ShellCommand

extension GitClient {
  
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
      lastMessage: {
        try ShellCommand(command: "git log -n 1 --format=%s")
          .run(in: zetDirectory)
      }
    )
  }
}
