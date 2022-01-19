import ArgumentParser
import Foundation
import ZetClient

struct LastCommand: ParsableCommand {
  
  static let configuration: CommandConfiguration = .init(
    commandName: "last",
    abstract: "Get the last modfied zet.",
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
    guard let last = try client.lastModifiedDirectory() else {
      throw LastError.notFound
    }
    let readme = last.appendingPathComponent("README.md")
    print(readme.path)
  }
  
  enum LastError: Error {
    case notFound
  }
}

