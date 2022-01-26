import ArgumentParser
import Foundation
import ZetClient

struct TitlesCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "titles",
    abstract: "Get all the titles of the zets.",
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
      .readmes()
      .titles()
      .toString()
      .print()
  }
}

extension Result where Success == ZetClient, Failure == Error {
  
  func readmes() -> Result<[URL], Error> {
    flatMap { $0.list(.readmes) }
  }
}

extension URL {
  
  fileprivate var title: String? {
    guard let string = try? String(contentsOf: self),
            let title = string.split(separator: "\n").first
    else { return nil }
    return title.replacingOccurrences(of: "# ", with: "")
  }
}

extension Result where Success == [URL], Failure == Error {
  
  func titles() -> Result<[(URL, String)], Error> {
    map { urls in
      urls.compactMap { url in
        guard let title = url.title else { return nil }
        return (url, title)
      }
    }
  }
}

extension Result where Success == [(URL, String)], Failure == Error {
  
  func toString() -> Result<String, Error> {
    map { items in
      items.map { "\($0.0.path): \($0.1)" }
      .joined(separator: "\n")
    }
  }
}
