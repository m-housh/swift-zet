import ArgumentParser
import Foundation
import GitClient

struct SearchCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "search",
    abstract: "Search for the string in the zets.",
    discussion: "",
    version: VERSION ?? "0.0.0",
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  @Argument(help: "The string to search for.")
  var search: [String]
  
  func run() throws {
    try directoryOption.zetClient()
      .flatMap { $0.git(.grep(search: search.joined(separator: " "))) }
      .print()
  }
}
