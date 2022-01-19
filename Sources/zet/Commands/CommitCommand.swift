import ArgumentParser
import Foundation
import GitClient

struct CommitCommand: ParsableCommand {
  
  private static let discussion = """
  If you would like to use the last commit message then you can supply the flag `--last` or `-l`.
  
  You can also use `zet commit last` or `zet commit` without a message to accomplish the same thing.
  
  """
  
  static let configuration: CommandConfiguration = .init(
    commandName: "commit",
    abstract: "Commit the zets to git.",
    discussion: discussion,
    version: VERSION,
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  @Flag(inversion: .prefixedNo, help: "Enable or disable pushing to remote")
  var push: Bool = true
  
  @Flag(name: .shortAndLong, help: "Use the last commit message as the message for this commit.")
  var last: Bool = false
  
  @Argument var message: [String]
  
  func run() throws {
    var message = message
    
    if message.count == 0 {
      message.append("last")
    }
    
    if last {
      message = ["last"]
    }
    let gitClient = try directoryOption.gitClient()
    let commit = try gitClient.commit(message: message.joined(separator: " "))
    if push {
      try gitClient.push()
    }
    print(commit)
  }
}
