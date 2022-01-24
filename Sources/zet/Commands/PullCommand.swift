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
    try directoryOption.zetClient()
      .flatMap { $0.git(.pull) }
      .print()
  }
}
