import ArgumentParser
import Foundation
import GitClient

struct StatusCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "status",
    abstract: "Print the git status of the zets.",
    discussion: "",
    version: VERSION,
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  func run() throws {
    let client = try directoryOption.gitClient()
    let status = try client.status()
    print(status)
  }
}
