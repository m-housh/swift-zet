import ArgumentParser
import Foundation

@main
struct ZetCommand: ParsableCommand {
  static var configuration: CommandConfiguration = .init(
    commandName: "zet",
    abstract: "The zet command",
    discussion: "",
    version: VERSION ?? "0.0.0",
    shouldDisplay: true,
    subcommands: [
      CreateCommand.self, // keep this first since it's the default command
      CommitCommand.self,
      LastCommand.self,
      PullCommand.self,
      PushCommand.self,
      SearchCommand.self,
      StatusCommand.self,
      TitlesCommand.self
    ],
    defaultSubcommand: CreateCommand.self,
    helpNames: nil
  )
}
