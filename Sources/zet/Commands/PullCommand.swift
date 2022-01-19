import ArgumentParser
import Foundation
import GitClient

struct PullCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "pull",
    abstract: "Pull repository from remote.",
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
    let pull = try client.pull()
    print(pull)
  }
}
