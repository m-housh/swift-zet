import ArgumentParser
import Foundation
import ZetClient

struct LastCommand: ParsableCommand {
  
  static let discussion = """
  Valid types are:
    assets: Print the path of the last modified assets directory.
    directory: Prints the path of the last modified zet directory.
    message: Prints the last commit message.
    readme: Prints the path of the last modified readme file.
  
  EXAMPLES:
    `zet last assets`
    `zet last directory`
    `zet last message`
    `zet last readme`
  """
  
  static let configuration: CommandConfiguration = .init(
    commandName: "last",
    abstract: "Get the the last modfied <type>.",
    discussion: discussion,
    version: VERSION,
    shouldDisplay: true,
    subcommands: [],
    defaultSubcommand: nil,
    helpNames: nil
  )
  
  @OptionGroup var directoryOption: DirectoryOption
  
  @Argument(help: "The type to get the last modified version of.")
  var type: LastType = .readme
  
  func run() throws {
    try directoryOption.zetClient()
      .flatMap { client -> Result<String, Error> in
        switch type {
        case .message:
          return client.git(.lastMessage)
        case .directory:
          return client.lastModified(.directory).path()
        case .assets:
          return client.lastModified(.assets).path()
        case .readme:
          return client.lastModified(.readme).path()
        }
      }
      .print()
  }
  
  enum LastType: String, ExpressibleByArgument {
    case assets
    case directory
    case message
    case readme
  }
    
}

