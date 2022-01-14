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
  
  @OptionGroup var configOption: ConfigOption
  
  func run() throws {
    let client = try configOption.gitClient()
    let pull = try client.pull()
    print(pull)
  }
}
