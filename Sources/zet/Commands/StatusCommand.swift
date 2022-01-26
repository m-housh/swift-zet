import ArgumentParser
import Foundation
import GitClient

struct StatusCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "status",
    abstract: "Print the git status of the zets.",
    discussion: "",
    version: VERSION ?? "0.0.0",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  func run() throws {
    try directoryOption.zetClient()
      .flatMap { $0.git(.status) }
      .print()
  }
}
