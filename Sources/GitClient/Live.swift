import Foundation
import ShellCommand

extension GitClient {
  
  public static func live(zetDirectory: URL, environment: [String: String]? = nil) -> Self {
    .init(
      handle: { request in
          Result {
            try request.shellCommand
              .run(in: zetDirectory, environment: environment)
              .shellOutput()
          }
      }
    )
  }
  
#if DEBUG
  public static let testing = Self.init(
    handle: { request in
        .success(request.shellCommand.command)
    })
#endif
}
