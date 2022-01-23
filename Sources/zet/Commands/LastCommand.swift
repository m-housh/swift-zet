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
    let client = try directoryOption.client()
    let url: URL?
    switch type {
    case .message:
      let gitClient = try directoryOption.gitClient()
      let message = try gitClient.lastMessage()
      print(message)
      return // early out for git message because it's not a url.
    case .assets:
      url = try client.lastModified(.assets)
    case .directory:
      url = try client.lastModified(.directory)
    case .readme:
      url = try client.lastModified(.readme)
    }
    guard let url = url else {
      throw LastError.notFound
    }
    print(url.path)
  }
  
  enum LastError: Error {
    case notFound
  }
  
  enum LastType: String, ExpressibleByArgument {
    case assets
    case directory
    case message
    case readme
  }
    
}

