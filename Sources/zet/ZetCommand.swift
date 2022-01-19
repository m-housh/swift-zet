import ArgumentParser
import Foundation

@main
struct ZetCommand: ParsableCommand {
  static var configuration: CommandConfiguration = .init(
    commandName: "zet",
    abstract: "The zet command",
    discussion: "",
    version: VERSION,
    shouldDisplay: true,
    subcommands: [
      CommitCommand.self,
//      ConfigCommand.self,
      CreateCommand.self,
      PullCommand.self,
      PushCommand.self,
      SearchCommand.self,
      TitlesCommand.self
    ],
    defaultSubcommand: CreateCommand.self,
    helpNames: nil
  )
}
