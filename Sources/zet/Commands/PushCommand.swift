import ArgumentParser
import Foundation
import GitClient

struct PushCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "push",
    abstract: "Push repository to remote.",
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
      .flatMap { $0.git(.push) }
      .print()
  }
}
