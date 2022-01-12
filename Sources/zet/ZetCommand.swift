import ArgumentParser
import Foundation
//import ZetManager

@main
struct ZetCommand: ParsableCommand {
  static var configuration: CommandConfiguration = .init(
    commandName: "zet",
    abstract: "The zet command",
    discussion: "",
    version: "0.1",
    shouldDisplay: true,
    subcommands: [ConfigCommand.self, NewCommand.self],
    defaultSubcommand: nil,
    helpNames: nil
  )
}
