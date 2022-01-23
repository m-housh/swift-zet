import ArgumentParser
import Foundation
import ZetClientLive

struct TitlesCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "titles",
    abstract: "Get all the titles of the zets.",
    discussion: "",
    version: VERSION,
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  func run() throws {
    let client = try directoryOption.client()
    let titles = try client.titles()
      .map({ "\($0.0.path): \($0.1)" })
      .joined(separator: "\n")
    print(titles)
  }
}
