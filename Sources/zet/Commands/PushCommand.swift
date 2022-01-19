import ArgumentParser
import Foundation
import GitClient

struct PushCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "push",
    abstract: "Push repository to remote.",
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
    let push = try client.push()
    print(push)
  }
}
