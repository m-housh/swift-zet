import ArgumentParser
import Foundation
import GitClient

struct SearchCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "search",
    abstract: "Search for the string in the zets.",
    discussion: "",
    version: VERSION,
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var configOption: ConfigOption
  
  @Argument(help: "The string to search for.")
  var search: [String]
  
  func run() throws {
    let search = search.joined(separator: " ")
    let gitClient = try configOption.gitClient()
    let results = try gitClient.grep(search: search)
    print(results)
  }
}
