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
  
  @OptionGroup var configOption: ConfigOption
  
  func run() throws {
    let client = try configOption.client()
    let titles = try client.titles()
      .map({ "\($0.0.path): \($0.1)" })
      .joined(separator: "\n")
    print(titles)
  }
}

fileprivate func urlString(url: URL) -> String {
  var url = url
  let readme = url.lastPathComponent
  url.deleteLastPathComponent()
  let dirname = url.lastPathComponent
  return "\(dirname)/\(readme)"
}
